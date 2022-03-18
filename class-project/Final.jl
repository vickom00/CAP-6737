### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 07205730-44c6-42ad-9fce-86407f743d52
using PlotlyBase

# ╔═╡ bccd6739-c5e5-405a-ae5a-48a5b8c3360f
using XLSX

# ╔═╡ fd213adf-0421-4acf-a0c2-d03aeed22ab0
using CSV, DataFrames, Graphs, GraphPlot

# ╔═╡ 6ca36333-fa75-44af-9e41-6eff1b5ba364
md"""
# CAP 6318 project
"""

# ╔═╡ 53b5e549-d931-4b78-a751-133cdfbf267f
md"""
### Project Title: Huawei Social Network Data
"""

# ╔═╡ 23f326d9-8b16-434b-bc72-de7dad5a6802
md"""
#### Project Description
The data was obtained from [Kaggle](https://www.kaggle.com/andrewlucci/huawei-social-network-data), and it was collected by crawling the social media platforms i.e. Facebook, Twitter and Instagram Huawei pages. This is a sample size of a communication network between number of people who use their social media to interact with Huawei.
"""

# ╔═╡ 965907cd-c8c3-4f8b-88a9-c62848695b38
md"""
The data was divided into three parts coming from Facebook, Instagram and Twitter.
- Huawei Facebook Communication Network is undirected and labeled having 1000 nodes and 50153 edges
- Huawei Twitter Communication Network is undirected and labeled having 1000 Nodes and 250315 edges
- Huawei Instagram Communication Network is undirected and labeled having 1000 Nodes and 4933 edges
"""

# ╔═╡ 42388743-794d-49e8-a018-699ba862c7d3
md"""
We will be exploring the relationship between the nodes(people) by using the concepts of the graph network learned in class. Additionally, we will be trying to identify the influential people in the network.
"""

# ╔═╡ 3c4408cf-75c8-4bd7-b220-701252fe5ceb
md"""
#### Data
"""

# ╔═╡ 9949a696-49a8-11ec-12c0-87bab4e28231
# import the facebook data
facebook_data = DataFrame(XLSX.readtable("/Users/victoromomola/Downloads/Facebook_Data.xlsx", "Sheet1")...)

# ╔═╡ 248ab7c9-9f69-4539-8dbd-35478c178984
md"""
This is the facebook data adjacency matrix which samples 1000 people along with their connections to each other.
"""

# ╔═╡ c14a2fec-d3ca-40aa-bb12-4e5356bac775
# import the twitter data
twitter_data = DataFrame(XLSX.readtable("/Users/victoromomola/Downloads/Twitter_Data.xlsx", "Sheet1")...)

# ╔═╡ b5b6f11d-1a65-4ae8-a2aa-10f6a3451169
md"""
This is the twitter data adjacency matrix which samples 1000 people along with their connections to each other.
"""

# ╔═╡ 535efad9-3f8b-4cbc-aaeb-11590eb34d62
# import the instagram data
instagram_data = DataFrame(XLSX.readtable("/Users/victoromomola/Downloads/Instagram_Data.xlsx", "Sheet1")...)

# ╔═╡ a8bebce2-7f5d-4600-a2fa-8b796202eccc
md"""
This is the instagram data adjacency matrix which samples 1000 people along with their connections to each other.
"""

# ╔═╡ 241d761d-a5d5-4e70-8577-421804401b15
md"""
## Graph Analysis
"""

# ╔═╡ 416be840-7553-470c-951a-1374edcac8a5
md"""
#### Instagram Network
"""

# ╔═╡ d2bf27fa-a3e8-4c35-9446-7015354b918f
# instagram graph
begin
	edges3 = Matrix(instagram_data[!, 2:1001])
	insta_graph = Graph(edges3)
end

# ╔═╡ 96540cc7-be0f-405e-abc0-c7f978f7b426
gplot(insta_graph,  layout=stressmajorize_layout)

# ╔═╡ c3c4cb07-1fc2-4aa7-96c6-17f926290c2d
is_connected(insta_graph) # The instagram network is a connected graph

# ╔═╡ 5d62e976-bf26-42c7-a8ae-c3e6c129dfc5
global_clustering_coefficient(insta_graph)

# ╔═╡ f6a6b3a3-a241-4bb1-a0df-bba0abbd7334
md"""
The global clustering coefficient shows that 0.0084 of its triangles are closed in the network. This means that the neighborhoods of almost all nodes are not connected to each other. The network is not very clustered.
"""

# ╔═╡ 4ce30c30-24da-4e85-a378-edbd49262eea
instagram_data.total = sum(eachcol(instagram_data[:,2:1001])) # total degrees for each connection

# ╔═╡ 640c4908-a9d2-4498-bf53-a98064eb6229
degree_table = sort(DataFrame(Names =instagram_data.Names, Connections = instagram_data.total), :Connections, rev=true)

# ╔═╡ 60852441-5803-49f3-93b1-e7c40c3162f7
md"""
The degree table shows the number of connections each person have. We see that Alexis, Ishku Ishku and Alveena have the highest connections in the instagram network.
"""

# ╔═╡ 4cf0dbb0-01b0-4813-9116-7f9ce67fe4f5
between_table = sort(DataFrame(Names =instagram_data.Names, Betweenness_centrality = betweenness_centrality(insta_graph)), :Betweenness_centrality, rev=true)

# ╔═╡ 55d607d2-bd4d-4009-a7b8-02c11a726e7a
md"""
The betweenness centrality means there are some or a lot of users that have a strong influence on the network. They act as a bridge to other parts of the network. This is how we are able to tell who the most influential user is. This between table shows that Alveena, Ishku Ishku and KH Hassan are part of the most influential in the network.
"""

# ╔═╡ 46df09f0-20ef-4f07-b67c-8223783f786c

begin
Plot(bar(x=between_table.Names[1:10], y = between_table.Betweenness_centrality[1:10]), Layout(height=400, title="Betweenness Centrality", xaxis_title="Node names",))
end

# ╔═╡ 8278a047-2526-4872-b808-76ac4f4b3d87
md"""
The bar chart above shows the betweenness centrality of each node in the network. These users can be seen as the connectors to different parts of the graph. We can see the top 10 influential nodes over the flow of information in the network. The most influential node is Alveena, but not by much. You can see that the next two nodes are right behind this user showing that it is not just one person spreading the news and reacting to posts the most, but rather multiple users contributing almost equally. 
"""

# ╔═╡ 75be6d93-a8c2-481d-9b67-3a913732e014
md"""
#### Facebook Network
"""

# ╔═╡ 8e1664d3-af52-46a5-921f-4e4ca2bd8155
# facebook graph
begin
	edges = Matrix(facebook_data[!, 2:1001])
	facebook_graph = Graph(edges)
end

# ╔═╡ 4074e3ba-7966-4fd7-a92b-a87836534a08
#gplot(facebook_graph) 

#WARNING!!! this plot takes some time to load because it is large

# ╔═╡ 0fca1444-6919-46f6-bfcc-4d138c644ac6
is_connected(facebook_graph) # The facebook network is a connected graph

# ╔═╡ 758770cf-ab1b-4865-9c8c-b3414015ed80
global_clustering_coefficient(facebook_graph)

# ╔═╡ 98e2a16c-3718-4eb3-8c44-0fe33dc54257
md"""
The global clustering coefficient shows that 0.1 of its triangles are closed in the network. This means that the neighborhoods of almost all nodes are not connected to each other. The network is not very clustered. Although it is more clustered than instagram. 
"""

# ╔═╡ 8c855d0b-2016-4a95-957b-269b7f7a939e
facebook_data.total = sum(eachcol(facebook_data[:,2:1001])) # total degrees for each connection

# ╔═╡ f6a19d3e-6e67-4a8d-a74f-562c201dfe90
fb_degree_table = sort(DataFrame(Names =facebook_data.Name, Connections = facebook_data.total), :Connections, rev=true)

# ╔═╡ 41416559-b05f-450e-b634-4ac706bc9f0e
# you can write something about the connections

# ╔═╡ b75d0e45-e763-45fc-8aa1-45da0e13c0c6
fb_between_table = sort(DataFrame(Names =facebook_data.Name, Betweenness_centrality = betweenness_centrality(facebook_graph)), :Betweenness_centrality, rev=true)

# ╔═╡ 7b861ead-8d48-4673-89f6-4fbfcc13d00f
md"""
The betweenness centrality means there are some/a lot of users that have a strong influence on the network. They act as a bridge to other parts of the network. This is how we are able to tell who the most influential user is. This facebook between table shows that Ernie, Engkos Kosasih and Sylvia are part of the most influential in the network.
"""

# ╔═╡ 6f90b0da-bd0d-4556-ad34-aaaf45ad3b9e
Plot(bar(x=sort(fb_between_table, :Betweenness_centrality, rev=true).Names[1:10], y = sort(fb_between_table, :Betweenness_centrality, rev=true).Betweenness_centrality[1:10]), Layout(height=400, title="Betweenness Centrality", xaxis_title="Node names",))

# ╔═╡ 6c2fccb7-1b2c-43e0-9291-9261df227c64
md"""
This chart shows the top 10 most influential users in the network. The most influential is Ernie by not much. This means that one/more user(s) spread information to the network (equally). 
"""

# ╔═╡ e05d25d0-5561-4c9f-b93e-cc7575803b82
md"""
#### Twitter Network
"""

# ╔═╡ 70db95dc-9910-4289-9266-9fbcea78fd9a
# twitter graph
begin
	edges2 = Matrix(twitter_data[!, 2:1001])
	twitter_graph = Graph(edges2)
end

# ╔═╡ 5990aaaa-9c86-48e8-8b9b-a6e25100a742
#gplot(twitter_graph)

#WARNING!!! this plot takes some time to load because it is large

# ╔═╡ 475730b1-9144-4540-b313-11695408701b
is_connected(twitter_graph)

# ╔═╡ fcfc2864-bc78-4dd9-aa84-275b30d5c58b
global_clustering_coefficient(twitter_graph)

# ╔═╡ 4ac2175d-31e4-477b-a9cb-cc93d379cfaa
md"""
The global clustering coefficient shows that 0.5012 of its triangles are closed in the network. This means that the neighborhoods of almost all nodes are (not) connected to each other. The network is (not very) clustered. Although it is more/less clustered than instagram/facebook.
"""

# ╔═╡ 893813dc-7e6e-4fb4-b8de-ea231d9faff7
twitter_data.total = sum(eachcol(twitter_data[:,2:1001])) # total degrees for each connection

# ╔═╡ df85c995-5255-4312-8185-49777792d25e
tw_degree_table = sort(DataFrame(Names =twitter_data.Names, Connections = twitter_data.total), :Connections, rev=true)

# ╔═╡ 60ed9f6f-5616-413b-a87b-c7d54c55f1e7
# you can write something about the connections

# ╔═╡ 01f095b2-5ed6-4cf4-a7fb-88007af14d5c
tw_between_table = sort(DataFrame(Names =twitter_data.Names, Betweenness_centrality = betweenness_centrality(twitter_graph)), :Betweenness_centrality, rev=true)

# ╔═╡ e09d1a43-46ee-4c7f-9054-5b8a5c39b93c
md"""
The betweenness centrality is means there are some/a lot of users that have a strong influence on the network. They act as a bridge to other parts of the network. This is how we are able to tell who the most influential user is. This twitter between table shows that Homer, Ellis and Dililah are part of the most influential in the network.
"""

# ╔═╡ 9cbe2a51-7c08-4b04-88ff-c5beb10cf836
begin
Plot(bar(x=tw_between_table.Names[1:10], y = tw_between_table.Betweenness_centrality[1:10]), Layout(height=400, title="Betweenness Centrality", xaxis_title="Node names",))
end

# ╔═╡ ad8b8a62-b98b-45a8-b8d6-f41e2f57db28
md"""
This chart shows the top 10 most influential users in the network. The most influential is Homer by not so much. This means that one/more user(s) spread information to the network (equally). 
"""

# ╔═╡ f9d263bc-0a69-4657-82b8-0863509d0ec6
md"""
## Limitations to our Project
"""

# ╔═╡ d367eb57-04c0-4db5-8375-7c375c72b8d4
md"""
We wanted to do more analysis like finding if there was homophily in facebook, twitter and instagram networks but we could not because the data did not contain more information like their characteristics which could have been helpful.

"""

# ╔═╡ 6a512ece-5635-4280-aedf-df7843f42839
md"""
## Final Conclusion
"""

# ╔═╡ 1b126a7f-8dac-493e-a5ec-60d5e5f2b7a4
# you can add your thoughts

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
CSV = "~0.9.11"
DataFrames = "~1.2.2"
GraphPlot = "~0.5.0"
Graphs = "~1.4.1"
PlotlyBase = "~0.8.18"
XLSX = "~0.7.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "49f14b6c56a2da47608fe30aed711b5882264d7a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.11"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "c6461fc7c35a4bb8d00905df7adafcff1fe3a6bc"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.2"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "618835ab81e4a40acf215c98768978d82abc5d97"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.16"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GraphPlot]]
deps = ["ArnoldiMethod", "ColorTypes", "Colors", "Compose", "DelimitedFiles", "Graphs", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "5e51d9d9134ebcfc556b82428521fe92f709e512"
uuid = "a2cc645c-3eea-5389-862e-a155d0052231"
version = "0.5.0"

[[Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "92243c07e786ea3458532e199eb3feee0e7e08eb"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.4.1"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "f45b34656397a1f6e729901dc9ef679610bd12b5"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.8"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

[[XLSX]]
deps = ["Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "96d05d01d6657583a22410e3ba416c75c72d6e1d"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.7.8"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "3593e69e469d2111389a9bd06bac1f3d730ac6de"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.4"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─6ca36333-fa75-44af-9e41-6eff1b5ba364
# ╟─53b5e549-d931-4b78-a751-133cdfbf267f
# ╟─23f326d9-8b16-434b-bc72-de7dad5a6802
# ╟─965907cd-c8c3-4f8b-88a9-c62848695b38
# ╟─42388743-794d-49e8-a018-699ba862c7d3
# ╟─3c4408cf-75c8-4bd7-b220-701252fe5ceb
# ╠═07205730-44c6-42ad-9fce-86407f743d52
# ╠═bccd6739-c5e5-405a-ae5a-48a5b8c3360f
# ╠═fd213adf-0421-4acf-a0c2-d03aeed22ab0
# ╟─9949a696-49a8-11ec-12c0-87bab4e28231
# ╟─248ab7c9-9f69-4539-8dbd-35478c178984
# ╟─c14a2fec-d3ca-40aa-bb12-4e5356bac775
# ╟─b5b6f11d-1a65-4ae8-a2aa-10f6a3451169
# ╟─535efad9-3f8b-4cbc-aaeb-11590eb34d62
# ╟─a8bebce2-7f5d-4600-a2fa-8b796202eccc
# ╟─241d761d-a5d5-4e70-8577-421804401b15
# ╟─416be840-7553-470c-951a-1374edcac8a5
# ╠═d2bf27fa-a3e8-4c35-9446-7015354b918f
# ╠═96540cc7-be0f-405e-abc0-c7f978f7b426
# ╠═c3c4cb07-1fc2-4aa7-96c6-17f926290c2d
# ╠═5d62e976-bf26-42c7-a8ae-c3e6c129dfc5
# ╟─f6a6b3a3-a241-4bb1-a0df-bba0abbd7334
# ╠═4ce30c30-24da-4e85-a378-edbd49262eea
# ╟─640c4908-a9d2-4498-bf53-a98064eb6229
# ╟─60852441-5803-49f3-93b1-e7c40c3162f7
# ╟─4cf0dbb0-01b0-4813-9116-7f9ce67fe4f5
# ╟─55d607d2-bd4d-4009-a7b8-02c11a726e7a
# ╟─46df09f0-20ef-4f07-b67c-8223783f786c
# ╟─8278a047-2526-4872-b808-76ac4f4b3d87
# ╟─75be6d93-a8c2-481d-9b67-3a913732e014
# ╠═8e1664d3-af52-46a5-921f-4e4ca2bd8155
# ╠═4074e3ba-7966-4fd7-a92b-a87836534a08
# ╠═0fca1444-6919-46f6-bfcc-4d138c644ac6
# ╠═758770cf-ab1b-4865-9c8c-b3414015ed80
# ╟─98e2a16c-3718-4eb3-8c44-0fe33dc54257
# ╠═8c855d0b-2016-4a95-957b-269b7f7a939e
# ╠═f6a19d3e-6e67-4a8d-a74f-562c201dfe90
# ╠═41416559-b05f-450e-b634-4ac706bc9f0e
# ╠═b75d0e45-e763-45fc-8aa1-45da0e13c0c6
# ╟─7b861ead-8d48-4673-89f6-4fbfcc13d00f
# ╟─6f90b0da-bd0d-4556-ad34-aaaf45ad3b9e
# ╟─6c2fccb7-1b2c-43e0-9291-9261df227c64
# ╟─e05d25d0-5561-4c9f-b93e-cc7575803b82
# ╠═70db95dc-9910-4289-9266-9fbcea78fd9a
# ╠═5990aaaa-9c86-48e8-8b9b-a6e25100a742
# ╠═475730b1-9144-4540-b313-11695408701b
# ╠═fcfc2864-bc78-4dd9-aa84-275b30d5c58b
# ╠═4ac2175d-31e4-477b-a9cb-cc93d379cfaa
# ╠═893813dc-7e6e-4fb4-b8de-ea231d9faff7
# ╠═df85c995-5255-4312-8185-49777792d25e
# ╠═60ed9f6f-5616-413b-a87b-c7d54c55f1e7
# ╠═01f095b2-5ed6-4cf4-a7fb-88007af14d5c
# ╟─e09d1a43-46ee-4c7f-9054-5b8a5c39b93c
# ╟─9cbe2a51-7c08-4b04-88ff-c5beb10cf836
# ╠═ad8b8a62-b98b-45a8-b8d6-f41e2f57db28
# ╟─f9d263bc-0a69-4657-82b8-0863509d0ec6
# ╟─d367eb57-04c0-4db5-8375-7c375c72b8d4
# ╟─6a512ece-5635-4280-aedf-df7843f42839
# ╠═1b126a7f-8dac-493e-a5ec-60d5e5f2b7a4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
