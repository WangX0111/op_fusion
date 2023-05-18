#include<bits/stdc++.h>

#include "mlir/Dialect/Shape/IR/Shape.h"  // TF:llvm-project
#include "mlir/IR/MLIRContext.h"          // TF:llvm-project
#include "mlir/IR/Matchers.h"
#include "mlir/Pass/Pass.h"               // TF:local_config_mlir
#include "mlir/Transforms/RegionUtils.h"  // TF:llvm-project
#include "mlir/Dialect/Linalg/IR/Linalg.h"

#include <llvm/Analysis/PostDominators.h>
#include <llvm/IR/Function.h>
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"

using namespace mlir;
using namespace std;
// using namespace catherine;

namespace mlir::catherine{
    
class FusionPass 
    : public PassWrapper<FusionPass,  OperationPass<ModuleOp>>  {
public:
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(FusionPass)
    StringRef getArgument() const final { return "fusion-pass"; }
    StringRef getDescription() const final { return "Fusion Pass."; }
    FusionPass() = default;
    FusionPass(const FusionPass &) {}

    void runOnOperation() override;
  
    void runOnBlock(Block *block);

  };

const int N=2e5+10;
int n,m,ans[N],dfn[N],id[N],tot,dep[N];
int ffa[N],fa[N],semi[N],val[N],du[N],ff[25][N];

queue<int>q,q1;
vector<int>cg[N];

struct node
{
    vector<int>edge[N];
    inline void add(int u,int v){edge[u].push_back(v);}
}a,b,c,d;

inline void dfs(int x,int f)
{
    dfn[x]=++tot,id[tot]=x,ffa[x]=f,c.add(f,x);
    for(int i=0;i<a.edge[x].size();++i) if(!dfn[a.edge[x][i]]) dfs(a.edge[x][i],x);
}

inline void dfs_ans(int x)
{
    ans[x]=1;
    for(int i=0;i<d.edge[x].size();++i) dfs_ans(d.edge[x][i]),ans[x]+=ans[d.edge[x][i]];
}

inline int find(int x)
{
    if(x==fa[x]) return x;
    int tmp=fa[x];fa[x]=find(fa[x]);
    if(dfn[semi[val[tmp]]]<dfn[semi[val[x]]]) val[x]=val[tmp];
    return fa[x];
}

inline int LCA(int x,int y)
{
    if(dep[x]<dep[y]) swap(x,y);
    int d=dep[x]-dep[y];
    for(int i=20;i>=0;i--) if(d&(1<<i)) x=ff[i][x];
    for(int i=20;i>=0;i--) if(ff[i][x]^ff[i][y]) x=ff[i][x],y=ff[i][y];
    return x==y?x:ff[0][x];
}

inline void tarjan()
{
    for(int i=n;i>=2;--i) 
    {
        if(!id[i]) continue;
        int x=id[i],res=n;
        for(int j=0;j<b.edge[x].size();++j)
        {
            int v=b.edge[x][j];
            if(!dfn[v]) continue;
            if(dfn[v]<dfn[x]) res=min(res,dfn[v]);
            else find(v),res=min(res,dfn[semi[val[v]]]);
        }
        semi[x]=id[res],fa[x]=ffa[x],c.add(semi[x],x);
    }
    for(int x=1;x<=n;x++) for(int i=0;i<c.edge[x].size();++i) du[c.edge[x][i]]++,cg[c.edge[x][i]].push_back(x);
    for(int x=1;x<=n;x++) if(!du[x]) q.push(x);
    while(!q.empty())
    {
        int x=q.front();q.pop();q1.push(x);
        for(int i=0;i<c.edge[x].size();++i) if(!--du[c.edge[x][i]]) q.push(c.edge[x][i]);
    }
    while(!q1.empty())
    {
        int x=q1.front(),f=0,len=cg[x].size();q1.pop();
        if(len) f=cg[x][0];
        for(int j=1;j<len;j++) f=LCA(f,cg[x][j]);
        ff[0][x]=f,dep[x]=dep[f]+1,d.add(f,x);
        for(int p=1;p<=20;p++) ff[p][x]=ff[p-1][ff[p-1][x]];
    }
}

void FusionPass::runOnOperation() {
    llvm::outs()<<"Fusion Pass:"<< "\n";
    auto moduleOp = getOperation();
    // DAG();
    // PostDominatorTree();
    // Fusion();
    llvm::outs() << "module";

    moduleOp->dump();
    moduleOp->walk([&](Operation* op){
   
      llvm::outs() << "op";
      op->dump();
      llvm::outs() << "block";

      op->getBlock()->dump();

    });
}


std::unique_ptr<Pass> createFusionPass() {
  return std::make_unique<FusionPass>();
}
}