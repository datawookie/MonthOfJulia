# LIGHTGRAPHS =========================================================================================================

using LightGraphs

# GRAPHS ==============================================================================================================

# Documentation on the Graphs package is at http://graphsjl-docs.readthedocs.org/en/latest/.

using Graphs

# There is also a GraphViz package which reads graphs specified in DOT format.

# CREATE GRAPH ALGORITHMICALLY ----------------------------------------------------------------------------------------

# There are numerous Graph Generator functions for generating a range of "standard" graphs.
#
g1a = simple_frucht_graph()
g1b = simple_star_graph(8)
g1c = simple_wheel_graph(8)

plot(g1a)

# CREATE GRAPH MANUALLY -----------------------------------------------------------------------------------------------

# Create a graph with 4 vertices.
#
g2 = simple_graph(4)

# Add some edges. Note that these are directed edges.
#
add_edge!(g2, 1, 2)
add_edge!(g2, 1, 3)
add_edge!(g2, 2, 3)

plot(g2)

# Is the graph directed?
#
is_directed(g2)

# -> Vertices
#
vertex_type(g2)
#
num_vertices(g2)
#
# Iterable list of vertices.
#
vertices(g2)
#
# Vertex indices (available for vertices of type ExVertex).
#
V1 = vertices(g2)[1]
V2 = vertices(g2)[2]
vertex_index(V1, g2)
#
# Degree and neighbours.
#
out_degree(V1, g2)
out_neighbors(V1, g2)
out_edges(V1, g2)
#
in_degree(V2, g2)
in_edges(V2, g2)

# -> Edges
#
edge_type(g2)
#
num_edges(g2)
#
# Iterable list of edges.
#
edges(g2)
#
# Edges indices.
#
E1 = edges(g2)[1]
edge_index(E1, g2)
#
# Source and target of edges.
#
source(E1)
target(E1)

# Print edges in graph.
#
for u in vertices(g2)
    for v in out_neighbors(u, g2)
        println("$u -> $v")
    end
end

# GRAPH ATTRIBUTES ----------------------------------------------------------------------------------------------------

V1 = ExVertex(1, "V1")
V1.attributes["size"] = 5.0
V2 = ExVertex(2, "V2")
V2.attributes["size"] = 3.0
V3 = ExVertex(3, "V3")

E1 = ExEdge(1, V1, V2)
E1.attributes["distance"] = 50
E1.attributes["color"] = "green"

# GRAPH TYPE: EDGE LIST -----------------------------------------------------------------------------------------------

# Graphs of type GenericEdgeList.

g3 = edgelist([V1, V2], [E1], is_directed = true)

# GRAPH TYPE: ADJACENCY LIST ------------------------------------------------------------------------------------------

# Graphs of type GenericAdjacencyList.

g4 = adjlist([V1, V2])

add_vertex!(g4, V3)

add_edge!(g4, V1, V2)
add_edge!(g4, V1, V3)

# GRAPH TYPE: INCIDENCE LIST ------------------------------------------------------------------------------------------

# Graphs of type GenericIncidenceList.

g5 = inclist([V1, V2, V3])

add_edge!(g5, V1, V2)

# GRAPH TYPE: GRAPH ---------------------------------------------------------------------------------------------------

# Graphs of type GenericGraph.

g6 = graph([V1, V2, V3], [E1])

add_edge!(g6, V2, V3)

# RANDOM GRAPHS -------------------------------------------------------------------------------------------------------

# Erdős–Rényi graphs.
#
g7a = erdos_renyi_graph(10, 0.2, is_directed = false)
g7b = erdos_renyi_graph(20, 0.3, is_directed = true)

# Watts-Strogatz graphs.
#
g8a = watts_strogatz_graph(100, 6, 0.0)
g8b = watts_strogatz_graph(100, 6, 0.1)

# TRAVERSAL -----------------------------------------------------------------------------------------------------------

# There are two other predefined visitor types: TrivialGraphVisitor and VertexListVisitor. 
#
traverse_graph(g1a, BreadthFirst(), 1, LogGraphVisitor(STDOUT))
traverse_graph(g1a, DepthFirst(), 6, LogGraphVisitor(STDOUT))

# CYCLE DETECTION -----------------------------------------------------------------------------------------------------

test_cyclic_by_dfs(g1a)
test_cyclic_by_dfs(g6)

# CONNECTED COMPONENTS ------------------------------------------------------------------------------------------------

# Identify subsets of vertices where each pair is linked by a path (by not necessarily by a single edge!). Isolated
# vertices are listed as separate components.
#
connected_components(g1a)

# CLIQUES -------------------------------------------------------------------------------------------------------------

# A clique is a set of vertices on an undirected graph where there is an edge between every pair of vertices.
#
# More details on https://en.wikipedia.org/wiki/Clique_(graph_theory).
#
maximal_cliques(g1a)

# SHORTEST PATHS ------------------------------------------------------------------------------------------------------

# Create edge distances, assuming that they all have same weight.
#
distances = ones(num_edges(g1a))

# Dijkstra's Algorithm.
#
d = dijkstra_shortest_paths(g1a, distances, 1)
#
# Vector of distances to all other vertices.
#
d.dists

# A* Algorithm (finding shortest path between two vertices).
#
shortest_path(g1a, distances, 1, 5)

# MINIMUM SPANNING TREE -----------------------------------------------------------------------------------------------

# Prim's Algorithm returns the edges for a minimum spanning tree starting at a particular vertex.
#
prim_minimum_spantree(g1a, distances, 1)

# Kruskal's Algorithm.
#
kruskal_minimum_spantree(g1a, distances)

# MATRICES ------------------------------------------------------------------------------------------------------------

# Adjacency matrix.
#
# Since the edges are directed, the matrix is asymmetric.
#
adjacency_matrix(g2)

# Weight matrix.
#
weight_matrix(g1a, distances)

# Distance matrix.
#
# Unconnected vertices are separated by Inf distance.
#
distance_matrix(g1a, distances)

# GRAPHCENTRALITY =====================================================================================================

using GraphCentrality

# EVOLVINGGRAPHS ======================================================================================================

using EvolvingGraphs

