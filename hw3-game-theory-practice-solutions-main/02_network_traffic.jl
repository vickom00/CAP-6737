### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ a345a565-fbf4-44e8-b1d6-22df286d7204
using LightGraphs, GraphPlot, SimpleWeightedGraphs, PlutoUI

# ╔═╡ c5832722-21f9-11ec-1b90-15910ca64476
md"""
# Network Traffic Practice

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon


**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 8
"""

# ╔═╡ 001ca80e-8f78-4a6f-89f6-d2913bfd968d
md"""
# E&K exercise 8.4

There are two cities, A and B, joined by two routes, I and II. All roads are one-way roads. There are 100 travelers who begin in city A and must travel to city B. Route I links city A to city B through city C. This route begins with a road linking city A to city C which has a cost-of-travel for each traveler equal to 0.5 + x/200, where x is the number of travelers on this road. Route I ends with a highway from city C to city B which has a cost-of-travel for each traveler of 1 regardless of the number of travelers who use it. Route II links city A to city B through city D. This route begins with a highway linking city A to city D which has a cost-of-travel for each traveler of 1 regardless of the number of travelers who use it. Route II ends with a road linking city D to city B which has a cost-of-travel for each traveler equal to 0.5 + y/200, where y is the number of travelers on this road.


These costs of travel are the value that travelers put on the time lost due to travel plus the cost of gasoline for the trip. Currently there are no tolls on these roads. So the government collects no revenue from travel on them. 

**(a)** Using LightGraphs.jl and GraphPlot.jl, create a weighted, directed graph that allows you to visualize the network described above. Make sure to label the edges with the cost-of-travel needed to move along the edge. The network should be a directed graph as all roads are one-way.

**(b)** Travelers simultaneously chose which route to use. Find Nash equilibrium values of x and y.

**(c)** Now the government builds a new (one-way) road from city C to city D. The new road is very short and has 0 cost-of-travel. Find a Nash equilibrium for the game played on the new network.

**(d)** What happens to total cost-of-travel as a result of the availability of the new road?

**(e)** The government is unhappy with the outcome in part (c) and decides to impose a toll on users of the road from city A to city C and to simultaneously subsidize users of the highway from city A to city D. They charge a toll of 0.125 to each user, and thus increase the cost-of-travel by this amount, for users of the road from city A to city C. They also subsidize travel, and thus reduce the cost-of-travel by this amount, for each user of the highway from city A to city D by 0.125. Find a new Nash equilibrium.

> If you are curious about how a subsidy could work you can think of it as a negative toll. In this economy all tolls are collected electronically, much as State of Florida attempts to do with its SunPass system. So a subsidy just reduces the total amount that highway users owe.]

**(f)** As you will observe in solving part (e) the toll and subsidy in part (e) were designed so that there is a Nash equilibrium in which the amount the government collects from the toll just equals the amount it loses on the subsidy. So the government is breaking even on this policy. What happens to total cost-of-travel between parts (c) and (e)? Can you explain why this occurs? Can you think of any break-even tolls and subsidies that could be placed on the roads from city C to city B, and from city D to city B, that would lower the total cost-of-travel even more?



"""

# ╔═╡ 7ed80fc7-4c53-46a5-a52b-fea5cfd71f76
md"""
## Answers

### Part a
"""

# ╔═╡ bc81743b-02d3-4079-b125-546603e8d0bd
function traffic_graph(x, y)
	A = [
		0 0 0.5+x/200 1;
		0 0 0 0;
		0 1 0 0;
		0 0.5+y/200 0 0
		]
	SimpleWeightedDiGraph(A)
end

# ╔═╡ 1ec8602d-245a-4923-94b5-60b3955e00db
function plot_traffic_graph(g::SimpleWeightedDiGraph)
	locs_x = [1.0, 3, 2, 2]
	locs_y = [1.0, 1, 0, 2]
	labels = collect('A':'Z')[1:nv(g)]
	gplot(g, locs_x, locs_y, nodelabel=labels, edgelabel=weight.(edges(g)))
end

# ╔═╡ 1d986add-774f-4a48-9108-ed262ebd8f28
@bind x Slider(0:100, default=50, show_value=true)

# ╔═╡ 03ce61a7-8ab6-406b-bf41-78e2e3900352
y = 100 - x

# ╔═╡ d28d9150-2fa1-430c-93e4-361de13cf9bf
g = traffic_graph(x, y)

# ╔═╡ 11df7be5-ee08-4c6c-811f-aef055eb85fe
plot_traffic_graph(g)

# ╔═╡ 9588438d-48c0-4e99-a371-28cf709f8989
md"""
### Part b

The unique NE is that 50 go A-C-B and 50 to A-D-B. For this strategy all players have a total commute time of 1.75. If any A-C-B driver deviates, they will have a commute time of 1 + 51/200 +0.4 > 1.75. Similarly, if any A-D-B driver deviates they will have commute time of 51/200 + 0.4 + 1 > 1.75

Consider that we have x < 50. Then one of the drivers on route A-D-B must have travel time > 1.75 (because y = 100 - x). They would benefit by deviating to A-C-B and getting a travel time <= 1.75 (strictly less than if x < 49)

Similar logic applies to an A-C-B driver deviating if x > 50
"""

# ╔═╡ 42f46f0b-240e-4679-9cc3-b130f3ae1b20
md"""
### Part c

The new NE is that all drivers take A-C-D-B. and have a total driving time of 2. Suppose someone tries to deviate

This is sad 😦

How does it happen. Suppose we start at 50 A-C-D drivers and 50 A-D-B drivers. All start with cost of 1.75. Each of the A-C-D drivers can get lower cost by switching (the last person is indifferent). This happens because they swap C-B (cost 1) for C-D-B (cost 0.5 + y/200, where max(y) = 100).

Now we are at 50 A-C-D-B drivers (cost 1.75) and 50 A-D-B  (cost 2) drivers. The A-D-B drivers all want to deviate and move to A-C-D-B (last driver is indifferent again). We are now left with total driving time of 2, but nobody can deviate and get a shorter commute

"""

# ╔═╡ 0ae12c5f-e7de-4f21-87c3-605173d14432
function traffic_graph2(x, y)
	A = [
		0 0 0.5+x/200 1
		0 0 0 0
		0 1 0 1e-18
		0 0.5+y/200 0 0
		]
	SimpleWeightedDiGraph(A)
end

# ╔═╡ 92e0bd0c-ddf0-472c-b8e9-4e60a6914d3f
@bind xc Slider(0:100, default=100, show_value=true)

# ╔═╡ 42bc6e58-fd5f-422f-a203-f139f9e6f6bb
@bind yc Slider(0:100, default=100, show_value=true)

# ╔═╡ 8ac31417-5daf-4172-8027-3d96269e036e
plot_traffic_graph(traffic_graph2(xc, yc))

# ╔═╡ 6812d963-1766-4916-8e93-8f0f8a0cc5bf
md"""
### Part d

Total cost of travel is now $100 \cdot 2 = 200$, whereas before it was $100 \cdot 1.75 = 175$
"""

# ╔═╡ 10dd6bb3-f429-484b-9e86-e9d8356f888c
md"""
### Part e

With the subsidy in place, we now have a NE where 50 drivers go A-C-D-B and 50 go A-D-B

Note that in the starting situation from part c (all on A-C-D-B) and new proposal all drivers take D-B with cost of 1. So we'll focus on what happens in the first part of the drive and compare A-C-D with A-D. 

How? Start from all 100 using A-C-D.  With the toll in place and all 100 drivers taking this has a cost of 1.125. The first 50 drivers have an incentive to deviate and drive A-D-B. Consider the first driver to take advantage of the subsidy. Their cost will change from 1.125 to the subsidized value of 0.875. As more drivers do this, the cost for driving A-C-D falls. Once 50 drivers have deviated, the cost for A-C-D will be 0.875, exactly equal to the cost of the subsidized route A-D. At this point nobody can benefit by deviating.

The new cost for each driver is 1.875

"""

# ╔═╡ 3588bca4-aca5-4b9e-9d76-13bb7d8c5a01
function traffic_graph3(x, y)
	A = [
		0 0 0.5+x/200 1
		0 0 0 0
		0 1 0 1e-18
		0 0.5+y/200 0 0
		]
	A[1, 3] += 0.125
	A[1, 4] -= 0.125
	SimpleWeightedDiGraph(A)
end

# ╔═╡ e63be9a0-8609-4b19-9bad-5d08ff0a5be4
@bind xd Slider(0:100, default=50, show_value=true)

# ╔═╡ 99015287-285f-4c69-9d04-69197e503b0c
@bind yd Slider(0:100, default=100, show_value=true)

# ╔═╡ 122e30df-679f-4da4-af69-62ee3f1f6634
plot_traffic_graph(traffic_graph3(xd, yd))

# ╔═╡ 17ea4390-9f1e-4963-a4bb-13660d3b1f07
md"""
### Part f

By implementing the toll+subsidy, the total travel time fell from $100 \cdot 2 = 200$ to $100 \cdot 1.875 = 187.5$. This happened because the government was able to see an inefficiency in the individual decision making that lead to sub-optimal social outcomes. The government was able to introduce additional cost/benefits to twist incentives in the right way to overcome some of this social cost, even though individuals couldn't do that on their own.

There are other schemes of toll+subsidy that would have net 0 cost to the government, but still decrease total travel cost.

Suppose we keep the toll/subsidy from part e and add an additional 0.125 toll for each driver that takes D-B and a 0.125 subsidy for all drivers taking C-B.

In this case, the new equilibrium outcome is 50 drivers on A-C-B and 50 on A-D-B. The total cost for every driver is now 1.75

If you remember, the original travel cost for all drivers before the C-D road was introduced was 1.75. Funny how that works 😉
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphPlot = "a2cc645c-3eea-5389-862e-a155d0052231"
LightGraphs = "093fc24a-ae57-5d10-9952-331d41423f4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SimpleWeightedGraphs = "47aef6b3-ad0c-573a-a1e2-d07658019622"

[compat]
GraphPlot = "~0.4.4"
LightGraphs = "~1.3.5"
PlutoUI = "~0.7.15"
SimpleWeightedGraphs = "~1.1.1"
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
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

[[Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "c6461fc7c35a4bb8d00905df7adafcff1fe3a6bc"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[GraphPlot]]
deps = ["ArnoldiMethod", "ColorTypes", "Colors", "Compose", "DelimitedFiles", "LightGraphs", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "dd8f15128a91b0079dfe3f4a4a1e190e54ac7164"
uuid = "a2cc645c-3eea-5389-862e-a155d0052231"
version = "0.4.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

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

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "633f8a37c47982bff23461db0076a33787b17ecd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.15"

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

[[SimpleWeightedGraphs]]
deps = ["LightGraphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "f3f7396c2d5e9d4752357894889a87340262f904"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.1.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╟─c5832722-21f9-11ec-1b90-15910ca64476
# ╟─001ca80e-8f78-4a6f-89f6-d2913bfd968d
# ╟─7ed80fc7-4c53-46a5-a52b-fea5cfd71f76
# ╠═a345a565-fbf4-44e8-b1d6-22df286d7204
# ╠═bc81743b-02d3-4079-b125-546603e8d0bd
# ╠═1ec8602d-245a-4923-94b5-60b3955e00db
# ╠═1d986add-774f-4a48-9108-ed262ebd8f28
# ╠═03ce61a7-8ab6-406b-bf41-78e2e3900352
# ╠═d28d9150-2fa1-430c-93e4-361de13cf9bf
# ╠═11df7be5-ee08-4c6c-811f-aef055eb85fe
# ╟─9588438d-48c0-4e99-a371-28cf709f8989
# ╟─42f46f0b-240e-4679-9cc3-b130f3ae1b20
# ╠═0ae12c5f-e7de-4f21-87c3-605173d14432
# ╠═92e0bd0c-ddf0-472c-b8e9-4e60a6914d3f
# ╠═42bc6e58-fd5f-422f-a203-f139f9e6f6bb
# ╠═8ac31417-5daf-4172-8027-3d96269e036e
# ╟─6812d963-1766-4916-8e93-8f0f8a0cc5bf
# ╟─10dd6bb3-f429-484b-9e86-e9d8356f888c
# ╠═3588bca4-aca5-4b9e-9d76-13bb7d8c5a01
# ╠═e63be9a0-8609-4b19-9bad-5d08ff0a5be4
# ╠═99015287-285f-4c69-9d04-69197e503b0c
# ╠═122e30df-679f-4da4-af69-62ee3f1f6634
# ╟─17ea4390-9f1e-4963-a4bb-13660d3b1f07
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
