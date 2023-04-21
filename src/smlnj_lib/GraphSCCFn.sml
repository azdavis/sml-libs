signature GRAPH_SCC = sig
  structure Nd : ORD_KEY
  type node = Nd.ord_key
  datatype component = SIMPLE of node | RECURSIVE of node list
  val topOrder' : { roots: node list, follow: node -> node list } -> component list
  val topOrder : { root: node, follow: node -> node list } -> component list
end

functor GraphSCCFn (Nd: ORD_KEY) :> GRAPH_SCC where Nd = Nd = struct end
