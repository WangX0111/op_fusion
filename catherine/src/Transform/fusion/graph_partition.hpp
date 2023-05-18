// 遍历Relay树，建立DAG用于后支配树分析
// 建立后支配树
// 应用算符融合算法

enum OpPatternKind {
  
 kElemWise = 0,
  
 kBroadcast = 1,
  
 kInjective = 2,
 kCommReduce = 3,
 
 kOutEWiseFusable = 4,
  
 kTuple = 7,
 kOpaque = 8
};

class IndexedForwardGraph {
 public:
  struct Node;

  struct Edge {
    Node* node{nullptr};
    OpPatternKind pattern{kOpaque};
  };

  struct Node {
    const tvm::Object* ref{nullptr};
    size_t index{0};
    OpPatternKind pattern{kOpaque};
    LinkedList<Edge> outputs;
  };
  std::unordered_map<const tvm::Object*, Node*> node_map;
  std::vector<Node*> post_dfs_order;

  /*! \brief Dump the graph into string. */
  void DebugDump() {
    std::ostringstream os;
    for (size_t i = 0; i < post_dfs_order.size(); ++i) {
      Node* node = post_dfs_order[i];
      ObjectRef object = GetRef<ObjectRef>(node->ref);
      os << "node[" << i << "], " << object->GetTypeKey() << " " << node->extern_ref << " "
         << node->pattern << " outputs=[";
      for (auto* link = node->outputs.head; link != nullptr; link = link->next) {
        os << link->value.node->index << " (" << link->value.pattern << "), ";
      }
      os << "]\n";
    }
    LOG(INFO) << "\n" << os.str();
  }
};

/*!
 * \brief Dominator tree that represent domination or
 *  post domination relation of the node.
 */
class DominatorTree {
 public:
  /*!
   * \brief A node in the dominator tree.
   */
  struct Node {
    /*! \brief The node in the tree */
    IndexedForwardGraph::Node* gnode{nullptr};
    /*! \brief parent of the tree */
    Node* parent{nullptr};
    /*! \brief current depth*/
    int depth{0};
    /*! \brief aggregated pattern to parent */
    OpPatternKind pattern{kOpaque};
  };
  // index -> node.
  std::vector<Node*> nodes;
  /*!
   * \brief compute a post dominator relation for a given dataflow graph.
   * \param arena The arena used for node allocation.
   * \param graph The graph to be analyzed.
   * \return The dominator tree of the graph.
   * \note This algorithm makes use of the fact that graph is DAG,
   *       and runs a single pass algorithm via LCA (Least Common Ancestor)
   */
  static DominatorTree PostDom(support::Arena* arena, const IndexedForwardGraph& graph);

 private:
  // Combine pattern together.
  inline static OpPatternKind CombinePattern(OpPatternKind lhs, OpPatternKind rhs) {
    if (lhs > rhs) return lhs;
    return rhs;
  }
  /*!
   * \brief Find the least common ancestor of the two nodes.
   * \param lhs The left node.
   * \param rhs The right node.
   * \param edge_pattern
   *        The combined edge pattern across all the parents.
   * \return The least common ancestor of the two.
   */
  static Node* LeastCommonAncestor(Node* lhs, Node* rhs, OpPatternKind* edge_pattern);
  /*!
   * \brief Find the least common ancestor of a list of nodes.
   * \param nodes the nodes.
   * \param edge_pattern
   *        The combined edge pattern across all the parents.
   * \return The least common ancestor of all nodes.
   */
  Node* LeastCommonAncestor(const LinkedList<IndexedForwardGraph::Edge>& input_nodes,
                            OpPatternKind* edge_pattern);

  /*!
   * \brief Convert the Node from an IndexedForwardGraph Node into DomaintorTree Node.
   * \param arena The Arena.
   * \param gnode An IndexedForwardGraph Node.
   * \return The DominatorTree Node.
   */
  Node* GetNode(support::Arena* arena, IndexedForwardGraph::Node* gnode);
};

class GraphPartitioner {
 public:
  explicit GraphPartitioner(support::Arena* arena, int opt_level, size_t max_fuse_depth)
      : arena_(arena), opt_level_(opt_level), max_fuse_depth_(max_fuse_depth) {}
  /*!
   * \brief Group as a union find data structure.
   */
  struct Group {
    /*! \brief The parent in the union find data structure. */
    Group* parent{nullptr};
    /*! \brief The pattern of the group */
    OpPatternKind pattern;
    /*! \brief reference to the root node. */
    const tvm::Object* root_ref{nullptr};
    /*!
     * \brief Reference to the anchor node,
     * this field is not nullptr only if pattern is kOutEWiseFusable.
     */
    const tvm::Object* anchor_ref{nullptr};
    /*!
     * \brief The number of nodes belonging to this group
     */
    uint32_t num_nodes{1};

    /*!
     * \brief Find the group root, perform path compression
     * \return The root type node.
     */
    Group* FindRoot();
  };
  /*!
   * \brief Partition a graph.
   * \return group assignments of each node.
   */
  std::vector<Group*> Partition(const IndexedForwardGraph& graph);

 private:
  /*! \brief The internal arena for temporary space. */
  support::Arena* arena_;
  /*! \brief optimization level for fuse operation. */
  int opt_level_;
  /*! \brief The maximum number of operations in one fused function */
  size_t max_fuse_depth_;
  /*! \brief The internal groups. */
  std::vector<Group*> groups_;
  /*! \brief internal field used for deduplication */
  std::unordered_set<IndexedForwardGraph::Node*> visited_;
  // Internal implementation of CheckPath
  template <typename F>
  bool CheckPath_(IndexedForwardGraph::Node* src, IndexedForwardGraph::Node* sink, F fcond);

  /*!
   * \brief Check all the node and edge pattern
   *  between src and sink satisfies fcond.
   *
   * src is not checked.
   *
   * \param src The source node.
   * \param sink The termination node.
   * \param fcond The condition to be checked.
   * \tparam F the condition function, with signature
   * \note sink must be a post-dominator of src.
   */
  template <typename F>
  bool CheckPath(IndexedForwardGraph::Node* src, IndexedForwardGraph::Node* sink, F fcond);

  /*!
   * \brief Merge the child group to the parent.
   * \param child The child group.
   * \param parent The parent group.
   */
  void MergeFromTo(Group* child, Group* parent);

  // Internal implementation of CommitFuse
  void CommitFuse_(IndexedForwardGraph::Node* src, IndexedForwardGraph::Node* sink, Group* target);

  /*!
   * \brief Commit fusion operation.
   * \param src The source node.
   * \param sink The termination node.
   * \note sink must be a post-dominator of src.
   */
  void CommitFuse(IndexedForwardGraph::Node* src, IndexedForwardGraph::Node* sink);

  size_t CountNodesUptoSink_(IndexedForwardGraph::Node* src, IndexedForwardGraph::Node* sink);

  // Count the number of nodes in a fused subgraph if child is additionally fused.
  // dom_parent is already known to be a part of the subgraph.
  // For a diamond structure, there can be multiple paths connecting child and dom_parent.
  // All intermediate nodes between child and dom_parent are taken into account.
  // Since dom_parent can itself be an intermediate node in the subgraph, calling FindRoot()
  // is important for correct calculation.
  size_t CountFusedNodesWithNewChild(IndexedForwardGraph::Node* child,
                                     IndexedForwardGraph::Node* dom_parent);

  // Initialize the groups.
  void InitGroups(const IndexedForwardGraph& graph);

  // execute the fusion algorithm.
  void RunFuse(const IndexedForwardGraph& graph, const DominatorTree& post_dom_tree, int phase);
};
