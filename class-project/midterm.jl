### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ 09ad6199-299b-4aa6-aab1-b05e77eef4e8
using DataFrames, CSV, Dates, HTTP

# ╔═╡ e5105247-34e8-4c1b-a91a-9c91a186bfe1
# NOTE: LightGraphs.jl recently renamed to Graphs.jl!!!!
using Graphs, SimpleWeightedGraphs

# ╔═╡ 153dd873-c8de-41cf-9505-124172363b4a
using PlutoUI

# ╔═╡ e9124b36-38c0-11ec-0a99-4552b5c6e500
md"""
# Midterm Exam

> Computational Analysis of Social Complexity
>
> Fall 2021
"""

# ╔═╡ fd7ecec9-9531-43cb-a7bc-5170df1b156e
md"""
## Q1: Graph Theory (20 points)

1. (10 points) Write one or two paragraphs describing what a graph/network is. Assume that your audience is a smart person, but one who knows nothing about programming or data analysis. In your discussion provide an example of a graph.
2. (E&K question 2.3) When we think about a single aggregate measure to summarize the distances between the nodes in a given graph, there are two natural quantities that come to mind. One is the diameter, which we define to be the maximum distance between any pair of nodes in the graph. Another is the average distance, which — as the term suggests — is the average distance over all pairs of nodes in the graph. In many graphs, these two quantities are close to each other in value. But there are graphs where they can be very different
    1. (5 points) Describe an example of a graph where the diameter is more than three times as large as the average distance.
    2. (5 points) Describe how you could extend your construction to produce graphs in which the diameter exceeds the average distance by as large a factor as you’d like. (That is, for every number c, can you produce a graph in which the diameter is more than c times as large as the average distance?)
"""

# ╔═╡ 62b90a48-011e-4d69-a4b7-5bae71ad10fb
md"""
1. A graph is a structure or a network made up of vertices and edges. A vertice or node refers to a point or a station in the graph and the edges refer to the link which connects a node with another node. The edges allow the nodes to form relationship with other nodes

2.
i. A graph where each node represents airport and the edges represent the flight. If you travelling from Texas to Florida it has a long diameter where it is thousands of miles versus the average path length of like 1 or 2 flights.

ii. I can use the same example above, in which the flight from another country the diameter is more than the average distance.
"""

# ╔═╡ 9a444248-c8c9-41a4-adf3-afb589e42a31
md"""
## Q2: Game Theory (20 points)

1. (5 points) True or false, all pure strategies are also mixed strategies. Defend your answer.
2. (5 points) True or false, all mixed strategies are also pure strategies. Defend your answer.
3. (5 points) Is a Nash Equilibrium always socially optimal (Pareto Optimal)? If so, explain why. If not, provide an example where they differed. What does your result say about the potential for governments to align behaviors?
4. (5 points) Explain the difference between a Nash Equilibrium strategy and a strictly dominating strategy.

"""

# ╔═╡ d816527e-6221-427d-b9c9-6f3ed90cea72
md"""
1. True. A pure strategy provides a complete definition of how a player will play a game. A player’s strategy set is the set of pure strategies available to that player. A mixed strategy is an assignment of a probability to each pure strategy.
2. True. Mixed strategies are an assignment of a probability to each pure strategy.
3. A Nash equilibrium is not always socially optimal. A Nash equilibrium is the best response to everyone's actions. A Pareto optimal is an outcome from which any attempt to benefit someone by deviating to some other outcome will necessarily result in a loss in satisfaction to someone else. For example in the prisoner's dilemma. The nash equilibrium was that they both confess and get a jail time of 4 years but if one of them chose to confess and the other did not it will result in one gaining and the other losing.
4. The difference between a nash equilibrium and a dominant strategy is that for NE it is the best response to what the other player chooses and the dominant strategy is that you always gain no matter what the other player chooses to play.
"""

# ╔═╡ 0b13647e-2b95-4ad4-9a39-fc929debc195
md"""
## Q3: ABM Theory (20 points)

1. (10 points) What are they key parts of an agent based model?
2. (10 points) Describe a research question for which an ABM might be an appropriate tool. You do not need to go into detail. 2-4 sentences should suffice.
"""

# ╔═╡ e42ae98f-ba5b-4a2b-b96a-651f830331b5
md"""
1. The key parts of an agent based model are made up of agents(which have a state and are independent of other agents), an environment(which can be fixed or varying) and the rules which makes an agent based model dynamic and how they interact with other agents.
2. We can use the ABM for wealth distribution. To study how wealth is distubuted in an environment. The agents can be the individual, the environment can be the country or state they reside in and the rules can state that an individual gives a portion of his wealth if they are friends with each other or neighbors. I think the conclusion for this will be that the wealth will not be distributed equally. It will not be balanced.
"""

# ╔═╡ 11eba231-9289-407d-b66f-75fbdb5cc4f9
md"""
## Q4: Julia Question (40 points)

In this question we will study the PageRank algorithm, made famous by Larry Page and Sergey Brin. It is the foundational algorithm upon which google's search engine was inititally implemented (and is still a prominent component).

The main intuition behind the algorithm is as follows.

> NOTE you do not need to understand all of this discussion in order to complete the exercise. I encourage you to read through it, work on the questions, and then come back and study the explanation again once you've seen how it works.

Consider a directed graph where nodes are web pages and an edge goes from A -> B if there is a link from website A to website B.

Furthermore, suppose that each webpage has a total of 1 "power" (or "attention", or "weight" -- use as synonyms) that it can allocate to other web pages.

The power for webpage A will be split evenly across all pages that are linked to from A.

For example, if site A has a link pointing to B, two links to C, and one to D then each B, C, and D would be given 1/3 of A's attention (even though there are two links to C -- it gets same attention as B and D).

Another way to think about this is in terms of transition probabilities. Suppose that you had a computer program that could collect a list of all unique, external links contained on webpage A. This program would collect [B, C, D]. Then, suppose you have the comptuer randomly follow one of the links on this list.

Now suppose you have the directed graph (or transition probabilities from the previous paragraph) in hand. You do the following experiment:

- Repeat $N$ times
    - Pick a starting node at random
    - For $T$ steps randomly traverse an edge (or, equivalently, follow transition probabilities for node of current step)
    - Record the node you end up on after $T$ steps

At the end of this procedure you will have an $N$ element list of node ids. The next step is to convert this array of node ids to an array of length n-nodes containing the frequency of each node appearing in your list of termianl nodes. This will be an approximation of what is called a *stationary* distribution.

Google would sort this array of node frequencies and return them to the user as the first search results.


**END OF EXPLANATION**

In this question we will apply the PageRank algorithm to outcomes of football (soccer) games played in the English Premier league. Our goal will be to use PageRank to sort all teams that have participated in the league according to their overall dominance in the league.

---

### Part 1: Importing the data (5 points)


The file at https://github.com/UCF-CAP-6318/midterm-exam/raw/main/epl_results.csv  contains data on the results of all EPL games played since inception, up until partway through the 2021-2022 season. It was obtained from a [kaggle dataset](https://www.kaggle.com/irkaal/english-premier-league-results)

Your task is to use the DataFrames and CSV packages to read the data into a DataFrame named `df`

> HINT: you might also want to use one of the Download or HTTP packages.


"""

# ╔═╡ 48dce300-dcf0-40a0-ba80-fb67472873fd
read_remote_csv(url) = DataFrame(CSV.File(HTTP.get(url).body, stringtype=String))

# ╔═╡ 528f97cb-3813-4950-a75a-e6de80f8cfa7
df = read_remote_csv("https://raw.githubusercontent.com/UCF-CAP-6318/midterm-exam/main/epl_results.csv") ## REPLACE THIS WITH YOUR CODE

# ╔═╡ 401c24c4-8b44-4a84-961a-3fb6d18382af
md"""
### Part 2 (5 points)

We now need to construct a list of all the teams that have played in the EPL

We'll also assign them a unique integer.

Your task is to fill in the two functions below that do these operations

See the docstrings for details on what the function is supposed to do
"""

# ╔═╡ fa3b6c65-8d8e-4a93-a321-6c168a7856e6
"get a sorted list of all unique teams that appear in the `HomeTeam` column"
get_teams(df) = sort(unique([x for x in df.HomeTeam]))

# ╔═╡ e1dfeb89-dbb7-4a69-85fd-71938ae5efca
"""
given a list of unique team names, create a dict mapping from the team name to an integer

Uses the `zip` function
"""
get_team_ids(teams) = Dict(zip(teams, 1:length(teams)))

# ╔═╡ 0ddbaca5-1d3a-4239-b0e7-7790c0168ee0
md"""
### Part 3: Build Weighted Graph (10 points)

The rules of the English Premier League are that the winning team of a match earns 3 points, the losing team earns 0, and both teams earn 1 point in the event of a draw.

The columns `HomeTeam` and `AwayTeam` provide the name of the two sides in a match.

The column `FTR` provides the "full time result" or the outcome of the game. It will be one of three values: `"H"` if the home won, `"A"` if the away team won and `"D"` if the game ended in a draw.

> NOTE: points are not the same as goals!

Following the logic of the PageRank algorithm we will say that the points earned by each team based on the match outcome were given away by the opposing side. For example, if Chelsea defeats Arsenal, then a total of 3 power would be assigned from Arsenal to Chelsea.

We will build a directed graph to summarize all the game outcomes. Each node in our graph represents a team in the EPL. An edge pointing from Arsenal to Chelsea will have a weight equal to the total number of official points Chelsea earned while playing games against Arsenal across all matches.

To build this graph we will build an adjacency matrix. Suppose Chelsea was given a team id of 7 and Arsenal was given a team id of 1. Then the (1, 7) entry of our adjacency matrix would be equal to the edge weight for Arsenal -> Chelsea, which (as noted in the previous paragraph) is equal to the number of official points Chelsea won as a result of matches played against Arsenal.

Your task is to fill in missing parts of the function below to correctly build the adjacency matrix and graph.
"""

# ╔═╡ e0d54df6-4dff-45e6-995f-27818e80fbb0
struct EPLResults
	df::DataFrame
	g::SimpleWeightedDiGraph
	teams::Vector{String}
	team_ids::Dict{String,Int}
end

# ╔═╡ fc32f990-d70b-405f-9047-df0dadff66bb
function create_epl_graph(df)
	teams = get_teams(df)
	team_ids = get_team_ids(teams)
	g = SimpleWeightedDiGraph(length(teams))


	# NOTE: right now `w` is a matrix of zeros of size (length(teams), length(teams))
	w = g.weights


	for r in eachrow(df)
		# `r` is one row of the DataFrame
		# you can access columns using `r.COLUMN_NAME`

		# TODO 1: extract `h_id` and `a_id` from `team_ids` given
		# 		  the name of the HomeTeam and AwayTeam for the
		#		  match represented in this row
		h_id = team_ids[r.HomeTeam]  # CHANGE ME
		a_id = team_ids[r.AwayTeam]  # CHANGE ME
		if r.FTR == "H"
			# TODO 2: change the right hand side to appropriate number
			# 		  based on home team winning
			w[a_id, h_id] += 3
		elseif r.FTR == "A"
			# TODO 3: change the indicies into `w` based on Away team winning
			# 	      (don't change right hand side)
			w[h_id, a_id] += 3
		elseif r.FTR == "D"
			# TODO 4: handle the case where each team gets one official point
			#		  from this match. NOTE: you will have to add weight to two
			#		  edges
			w[h_id, a_id] += 1
			w[a_id, h_id] += 1

		end
	end
	return EPLResults(df, g, teams, team_ids)
end

# ╔═╡ 81e21316-d767-4626-a11a-2274be2d5c60
md"""
### Part 4: Find Stationary Distribution (10 points)

Now that we have a routine that can properly construct our weighted DiGraph, we are ready to implement the core of the PageRank algorithm.

The first step is to determine the "transition probabilities" between nodes in our graph. We will do this using a stochastic matrix that we'll call P. This matrix can be computed by dividing each row of the matrix by the sum of that row. We've done this for you in the `trans_mat` function below.

We can simulate our process of randomly crossing edges of the graph according to those transition probabilities using some clever linear algebra.

Let `p` represent our best guess for the stationary distribution associated with our transition matrix. If this is truly a stationary distribution, then it will satisfy the identity `p = P' p` where `P'` represents the transpose of the transition stochastic matrix returned by `trans_mat`.

Now the clever part of our approach is that if we start from **any** initial `p` (as long as it is a proper probability distribution), if we multiply on the left by P' many times, we are *guaranteed* to converge to the stationary distribution.

Your task is to fill in the `compute_ranks` function below, which will implement that procedure.

"""

# ╔═╡ bcfe9c56-1af1-4e9c-9828-813bad03d2c2
trans_mat(g::SimpleWeightedDiGraph) = Array(g.weights) ./ sum(g.weights, dims=2)

# ╔═╡ 41f5b604-b621-4b62-a1b2-69946cc5abff
function compute_ranks(res::EPLResults)
	P = trans_mat(res.g)
	N = size(P, 1)

	# start with any valid distribution for `p`. we'll pick
	# a uniform distribution over the `N` nodes.
	p = fill(1 / N, N)
	done = false
	i = 0

	while !done && i < 100000
		i += 1
		new_p = P'p  # TODO: Change this line

		done = maximum(abs.(p .- new_p)) < 1e-10

		# copy values into `p` to prepare for next iteration
		copy!(p, new_p)
	end
	p
end

# ╔═╡ 8aaeec06-01d2-48d7-bf82-4cc0bf113fa7
compute_ranks()

# ╔═╡ 9162cb1a-43a2-453f-9846-c2283a2ec934
md"""
### Part 5: Interpretation (10 points)

Congrats! You've implemented a trillion dollar algorithm 👏

Let's see how we did.

Below I have used your routines to analyze two subsets of the data:

1. All the matches since the inception of the league
2. All matches from only the 2020-2021 season

Based on what you see [https://en.wikipedia.org/wiki/Premier_League](https://en.wikipedia.org/wiki/Premier_League) and [https://globalsportsarchive.com/competition/soccer/premier-league-2020-2021/regular-season/47188/](https://globalsportsarchive.com/competition/soccer/premier-league-2020-2021/regular-season/47188/), how did your algorithm do against the official rankings?

Discuss.
"""

# ╔═╡ bacd508d-cd92-45be-99b1-4db714a19e94
md"""
YOUR RESPONSE HERE
"""

# ╔═╡ a606a856-c0d1-494d-a247-23d88fddfae9
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

	almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

	still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

	keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

	yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

	correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

	not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

	check_number(have::Int, want::Int) = have == want
	check_number(have::T, want::T) where T <: AbstractFloat = abs(want - have) < 1e-10

	function default_checks(vname, have, want)
		if ismissing(have)
			still_missing(Markdown.MD(Markdown.Paragraph([
				"Make sure to compute a value for ",
				Markdown.Code(vname)
			])))
		elseif typeof(have) != typeof(want)
			keep_working(Markdown.MD(Markdown.Paragraph([
				Markdown.Code(vname),
				"should be a $(typeof(want)), found $(typeof(have))"
			])))
		else
			if !check_number(have, want)
				keep_working(Markdown.MD(Markdown.Paragraph([
				Markdown.Code(vname),
				"is not quite right"
			])))
			else
				correct()
			end
		end
	end
	nothing
end

# ╔═╡ 08ed5880-28dd-4863-8234-f6ff4d9e5ace
begin
	check_import(::Missing) = still_missing()
	check_import(::Any) = keep_working(md"`df` should be a DataFrame")
	function check_import(df::DataFrame)
		if size(df, 1) != 10874
			return keep_working(md"`df` should have 10874 rows")
		end
		if !all(in.(["Season", "HomeTeam", "AwayTeam", "FTR"], Ref(names(df))))
			return keep_working()
		end
		return correct()
	end
	check_import(df)
end

# ╔═╡ 7243269e-1333-4aa8-8625-6d2e44a24e6d
begin
	check_get_teams(::Missing) = still_missing()
	check_get_teams(::Any) = keep_working(md"`get_teams(df)` should return a vector of strings")
	function check_get_teams(x::Vector{<:AbstractString})
		if length(x) != 50
			return keep_working()
		end
		if !issorted(x)
			return keep_working(md"`get_teams(df)` should return a **sort**ed list")
		end
		correct()
	end
	check_get_teams(get_teams(df))

end

# ╔═╡ f062d296-d9bb-4e04-9a4f-41e0e055de5b
begin
	check_get_team_ids(::Missing) = still_missing()
	check_get_team_ids(::Any) = keep_working(md"`get_teams(df)` should return a dict mapping string to int")
	function check_get_team_ids(x::Dict{<:AbstractString,Int})
		if length(x) != 50
			return keep_working()
		end
		if length(values(x)) != length(unique(values(x)))
			return keep_working("each team must have a unique id")
		end
		correct()
	end
	check_get_team_ids(get_team_ids(get_teams(df)))

end

# ╔═╡ 477fe2ac-8231-41ed-afa3-f2eb7a827a5a
begin
	check_create_graph(::Missing) = still_missing(md"Make sure you have `df` defined above")
	function check_create_graph(df::DataFrame)
		have = create_epl_graph(df[df.Season .== "2020-21", :])
		if nv(have.g) != 20
			keep_working(md"Your graph should have 20 nodes")
		end
		if ne(have.g) != 265
			keep_working(md"Your graph should have 265 edges")
		end
		city = have.team_ids["Man City"]
		manu = have.team_ids["Man United"]
		if sum(have.g.weights[:, city]) != 86
			keep_working(md"Not right... keep trying")
		end

		if sum(have.g.weights[:, manu]) != 74
			keep_working(md"Not right... keep trying")
		end
		correct()

	end
	check_create_graph(df)
end

# ╔═╡ 4312fde3-eb72-4501-82e0-fc0fa9a92c4f
begin
	test_compute_ranks(::Missing) = still_missing(md"Make sure you've imported `df` above")
	function test_compute_ranks(df::DataFrame)
		_res = create_epl_graph(df[df.Season .== "2020-21", :])
		x = compute_ranks(_res)
		if abs(sum(x) -1 ) > 1e-10
			return keep_working(md"probablities do not sum to 1")
		end
		if any(x .< 0)
			return keep_working(md"all elements must be non-negative")
		end
		if findmax(x)[2] != _res.team_ids["Man City"]
			return keep_working()
		end
		if findmin(x)[2] != _res.team_ids["Sheffield United"]
			return keep_working()
		end
		correct()

	end
	test_compute_ranks(df)
end

# ╔═╡ e368a139-c3f7-49b3-8769-52e73ff14de0
begin
	function present_results(df::DataFrame)
		res = create_epl_graph(df)
		ranks = compute_ranks(res)
		team_ranks = sortperm(ranks, rev=true)
		DataFrame(
			position=1:length(team_ranks),
			team=[res.teams[i] for i in team_ranks]
		)
	end
	present_results(::Missing) = still_missing(md"Make sure you import `df` above")
end

# ╔═╡ 1ee16b92-66eb-4558-b344-2ba0e1220a22
present_results(df)

# ╔═╡ dd7fa7f3-780c-450c-8880-b4435c4210ba
# TODO: This will error if you haven't imported df yet
present_results(df[df.Season .== "2020-21", :])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SimpleWeightedGraphs = "47aef6b3-ad0c-573a-a1e2-d07658019622"

[compat]
CSV = "~0.9.10"
DataFrames = "~1.2.2"
Graphs = "~1.4.1"
HTTP = "~0.9.16"
PlutoUI = "~0.7.16"
SimpleWeightedGraphs = "~1.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "74147e877531d7c172f70b492995bc2b5ca3a843"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.10"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

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

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "d962b5a47b6d191dbcd8ae0db841bc70a05a3f5b"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.13"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "92243c07e786ea3458532e199eb3feee0e7e08eb"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.4.1"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "14eece7a3308b4d8be910e265c724a6ba51a9798"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.16"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

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

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

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

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d911b6a12ba974dabe2291c6d450094a7226b372"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

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

[[SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "c96ca0c9e3856e08508502821fd76583779de698"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.0"

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

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

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
# ╟─e9124b36-38c0-11ec-0a99-4552b5c6e500
# ╟─fd7ecec9-9531-43cb-a7bc-5170df1b156e
# ╟─62b90a48-011e-4d69-a4b7-5bae71ad10fb
# ╟─9a444248-c8c9-41a4-adf3-afb589e42a31
# ╟─d816527e-6221-427d-b9c9-6f3ed90cea72
# ╟─0b13647e-2b95-4ad4-9a39-fc929debc195
# ╟─e42ae98f-ba5b-4a2b-b96a-651f830331b5
# ╟─11eba231-9289-407d-b66f-75fbdb5cc4f9
# ╠═09ad6199-299b-4aa6-aab1-b05e77eef4e8
# ╠═48dce300-dcf0-40a0-ba80-fb67472873fd
# ╠═528f97cb-3813-4950-a75a-e6de80f8cfa7
# ╟─08ed5880-28dd-4863-8234-f6ff4d9e5ace
# ╟─401c24c4-8b44-4a84-961a-3fb6d18382af
# ╠═fa3b6c65-8d8e-4a93-a321-6c168a7856e6
# ╟─7243269e-1333-4aa8-8625-6d2e44a24e6d
# ╠═e1dfeb89-dbb7-4a69-85fd-71938ae5efca
# ╟─f062d296-d9bb-4e04-9a4f-41e0e055de5b
# ╟─0ddbaca5-1d3a-4239-b0e7-7790c0168ee0
# ╠═e5105247-34e8-4c1b-a91a-9c91a186bfe1
# ╠═e0d54df6-4dff-45e6-995f-27818e80fbb0
# ╠═fc32f990-d70b-405f-9047-df0dadff66bb
# ╟─477fe2ac-8231-41ed-afa3-f2eb7a827a5a
# ╟─81e21316-d767-4626-a11a-2274be2d5c60
# ╠═bcfe9c56-1af1-4e9c-9828-813bad03d2c2
# ╠═41f5b604-b621-4b62-a1b2-69946cc5abff
# ╠═8aaeec06-01d2-48d7-bf82-4cc0bf113fa7
# ╟─4312fde3-eb72-4501-82e0-fc0fa9a92c4f
# ╟─9162cb1a-43a2-453f-9846-c2283a2ec934
# ╟─e368a139-c3f7-49b3-8769-52e73ff14de0
# ╠═1ee16b92-66eb-4558-b344-2ba0e1220a22
# ╠═dd7fa7f3-780c-450c-8880-b4435c4210ba
# ╠═bacd508d-cd92-45be-99b1-4db714a19e94
# ╠═153dd873-c8de-41cf-9505-124172363b4a
# ╟─a606a856-c0d1-494d-a247-23d88fddfae9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
