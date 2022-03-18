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

# ╔═╡ 88ada2ea-42ea-4a2b-9aca-ddeff35d2238
using GameTheory

# ╔═╡ 3b1a5c78-16e7-471b-876c-4dc52763e021
using PlutoUI

# ╔═╡ ee9d5f2e-21f4-11ec-1c1f-2976e41f30dc
md"""
# Game Theory Practice

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon


**References**

- [Easley and Kleinberg](https://www.cs.cornell.edu/home/kleinber/networks-book/) chapter 6
"""

# ╔═╡ 012f578e-d972-430a-b70f-599ce0399237
md"""
### Answers

(a) Yes, player B is always better off by playing `L`

(b) (b, L)  is the only NE in PS. We know that player B will always play the dominant strategy `L`. Player A's unique best response to that is to play `b`.
"""

# ╔═╡ 3a6c382b-c44b-4b04-b3a6-e2b8d5895a37
md"""
### Answers

**(a)** (D, R) is the only NE in PS

**(b)** (U, L) is the only NE in PS

**(c)** (D, L) and (U, R) are NE in PS. There is also a NE in mixed strategies. We'll derive it below

Let player B play L with probability `q`. Then Player A's payoffs are:

$$E[p_A(U) | q] = q + 4(1-q)$$
$$E[p_A(D) | q] = 3q + 2(1-q)$$

Setting these two equal to eachother (making player A in different) gives $q + 4 - 4q = 3q + 2 - 2q$, which can be solved for $q = \frac{1}{2}$

Now consider that player A will play `U` with probability `p`. Then player B's expected payoffs for each pure strategy are:

$$E[p_B(L) | p] = p + 3(1-p)$$
$$E[p_B(R) | p] = 3p + 2(1-p)$$

Setting these two equal to eachother (making player B in different) gives $p + 3 - 3p = 2p + 2 - 2p$, which can be solved for $p = \frac{1}{2}$

Thus the NE in mixed strategies is [(1/2, 1/2), (1/2, 1/2)]

"""

# ╔═╡ a070ba38-3c92-4f8f-86dd-df81946fc707
neps_6_a = let
	bimatrix = zeros(2,2,2)
	bimatrix[1, 1, :] .= [2, 15]
	bimatrix[1, 2, :] .= [4, 20]
	bimatrix[2, 1, :] .= [6, 6]
	bimatrix[2, 2, :] .= [10, 8]
	g = NormalFormGame(bimatrix)
	pure_nash(g)
end

# ╔═╡ fffdf495-01ac-4982-ab5b-2e0af8bc5746
neps_6_b = let
	bimatrix = zeros(2,2,2)
	bimatrix[1, 1, :] .= [3, 5]
	bimatrix[1, 2, :] .= [4, 3]
	bimatrix[2, 1, :] .= [2, 1]
	bimatrix[2, 2, :] .= [1, 6]
	g = NormalFormGame(bimatrix)
	pure_nash(g)
end

# ╔═╡ 87d5bd5f-3cdc-4312-98a5-0f9068f9d22d
ne_6_c = let
	bimatrix = zeros(2,2,2)
	bimatrix[1, 1, :] .= [1, 1]
	bimatrix[1, 2, :] .= [4, 2]
	bimatrix[2, 1, :] .= [3, 3]
	bimatrix[2, 2, :] .= [2, 2]
	g = NormalFormGame(bimatrix)
	support_enumeration(g)
end

# ╔═╡ da357997-6eb4-47a7-be59-cc0ceb15ca96
md"""
### Answers

**(a)** (U, L) is the only NE in PS

**(b)** No. If that payoff is larger than player A's payoff for (D, L), then it will still be a NE. If we make player A's payoff for (U, L) $<=$ 2, then the NE moves to (D, L). see slider below

**(c)** Yes. If you set player B's payoff from (U, L) to anything less than 2, there is no NE in PS. Suppose $p_B((U, L)) = 1$. In this case there is no strategy where someone doesn't want to change.
"""

# ╔═╡ 59e89864-09d3-4b6b-b4d3-a627f75f0af4
@bind payoff_A_U_L Slider(0:0.1:4, show_value=true, default=3)

# ╔═╡ d8e712c0-3d9a-468b-ab05-3a860af5aaf3
@bind payoff_B_U_L Slider(0:0.1:4, show_value=true, default=3)

# ╔═╡ b32100f2-01bd-4294-92f2-7df05c56bee8
game_10_a = let
	bimatrix = zeros(2,2,2)
	bimatrix[1, 1, :] .= [payoff_A_U_L, payoff_B_U_L]
	bimatrix[1, 2, :] .= [1, 2]
	bimatrix[2, 1, :] .= [2, 1]
	bimatrix[2, 2, :] .= [3, 0]
	g = NormalFormGame(bimatrix)
end

# ╔═╡ d8bc5b05-c7b4-4a6e-bcbd-63b5d248340c
pure_nash(game_10_a)

# ╔═╡ ed296ca1-5ff8-4368-a171-9ce90462cde0


# ╔═╡ 4b1512ff-b2f4-4d08-8846-7db4639ec0ab
md"""
# E&K exercise 6.15

Two identical firms — let’s call them firm 1 and firm 2 — must decide simultaneously and independently whether to enter a new market and what product to produce if they do enter the market. Each firm, if it enters, can develop and produce either product A or product B. If both firms enter and produce product A they each lose ten million dollars. If both firms enter and both produce product B, they each make a profit of five million dollars. If both enter and one produces A while the other produces B, then they each make a profit of ten million dollars. Any firm that does not enter makes a profit of zero. Finally, if one firm does not enter and the other firm produces A it makes a profit of fifteen million dollars, while if the single entering firm produces B it makes a profit of thirty million dollars.

You are the manager of firm 1 and you have to choose a strategy for your firm.

**(a)** Set this situation up as a game with two players, firms 1 and 2, and three strategies for each firm: produce A, produce B or do not enter.

**(b)**  One of your employees argues that you should enter the market (although he is not sure what product you should produce) because no matter what firm 2 does, entering and producing product B is better than not entering. Evaluate this argument.

**(c)** Another employee agrees with the person in part (b) and argues that as strategy A could result in a loss (if the other firm also produces A) you should enter and produce B. If both firms reason this way, and thus enter and produce product B, will their play of the game form a Nash equilibrium? Explain.

**(d)** Find all the pure strategy Nash equilibria of this game.

**(e)** Another employee of your firm suggests merging the two firms and deciding co- operatively on strategies so as to maximize the sum of profits. Ignoring whether this merger would be allowed by the regulators do you think its a good idea? Explain.



"""

# ╔═╡ 61f7eb55-e6e5-4373-a87b-d0d66579cf4d
md"""
### Answers

**(a)**

$(game_table([0 0 0; 15 -10 10; 30 10 5], [0 15 30; 0 -10 10; 0 10 5], ["out", "A", "B"], ["out", "A", "B"]))

**(b)** This employee is correct! The strategy B dominates the strategy out. Regardless of what the other firm does, we are better off entering and producing B than we would be to stay out.

**(c)** No, the strategy (B,B) is not an equilibrium. For either firm, a deviation to producing A would be an improvement resulting in 10 million in profits instead of the 5 million they have from playing B

**(d)** The NE in Purse strategies include (A, B) and (B, A). In these cases any deviation from A to B would result in a drop of profit from 10 to 5. Any deviation from B to A would result in a drop of profit from 10 to -10. See code below.

**(e)** A merger would be a good idea. In this case the combined firm could decide to play strategy $B$, for total profits of 30, which is higher than the total combined profits of 20 that resulted in equilibrium before.
"""

# ╔═╡ 676a76a5-d7b8-4335-9c28-467d670214a1
game_6_15 = let
	payoffs1 = [0 0 0; 15 -10 10; 30 10 5]
	NormalFormGame(payoffs1)
end

# ╔═╡ 44f1223d-0ae6-441b-ad4b-8c4c17902c1b
pure_nash(game_6_15)

# ╔═╡ c69d62c6-9faf-480f-b6df-47a807f529a5
function game_table(payoffs1, payoffs2, strategies1, strategies2, name1="Player A", name2="Player B")
	@assert size(payoffs1) == size(payoffs2)
	n1, n2 = (length(strategies1), length(strategies2))
	@assert size(payoffs1) == (n1, n2)
	
	strat2_headings = map(x->"<th>$x</th>", strategies2)
	
	nrows = 2 + n1
	ncols = 2 + n2
	
	payoff_entry(i, j) = "<td> $(payoffs1[i,j]), $(payoffs2[i,j])</td>"
	
	function build_row_entries(i)
		payoffs = map(j -> payoff_entry(i, j), 1:n2)
		"""
		<th>$(strategies1[i])</th>
		$(join(payoffs, "\n"))
		"""
	end
	
	function build_row(i)
		extra = ""
		
		if i == 1
			extra = """<th rowspan="$(n1)">$(name1)</th>"""
		end
		
		return """
		<tr>
			$(extra)		
			$(build_row_entries(i))
		</tr>
		"""
	end
	
	rows = map(build_row, 1:n1)
		
	
	HTML("""
	<table>
	<tr>
		<th colspan="2"></th>
		<th colspan="$(n2)">$(name2)</th>
	</tr>
	<tr>
		<th colspan="2"></th>
		$(join(strat2_headings, "\n"))
	</tr>
	$(join(rows, "\n"))
	
	</table>
	""")
end

# ╔═╡ a450976f-9d82-40ce-aab0-5dd00813ba2a
md"""
# Q1 E&K exercise 6.4

Consider the two-player game with players, strategies and payoffs described in the
following game matrix.

$(game_table(
	[0 6 1; 2 0 7; 5 4 3],
	[3 2 1; 3 1 0; 3 2 1],
	["t", "m", "b"],
	["L", "M", "R"],
	"Player A",
	"Player B"
))

**(a)**  Does either player have a dominant strategy? Explain briefly (1-3 sentences)? 

**(b)** Find all pure strategy Nash equilibria for this game.
"""

# ╔═╡ 3c31f151-6fd4-49e9-9878-a8f51b6294c5
md"""
# Q2 E&K exercise 6.6

In this question we will consider several two-player games. In each payoff matrix below the rows correspond to player A’s strategies and the columns correspond to player B’s strategies. The first entry in each box is player A’s payoff and the second entry is player B’s payoff.

In each case 

**(a)** Find all pure (non-randomized) strategy Nash equilibria for the game described
by the payoff matrix below.

$(game_table([2 4; 6 10], [15 20; 6 8], ["U", "D"], ["L", "R"]))

**(b)** Find all pure (non-randomized) strategy Nash equilibria for the game described
by the payoff matrix below.

$(game_table([3 4; 2 1], [5 3; 1 6], ["U", "D"], ["L", "R"]))


**(c)** Find all Nash equilibria for the game described
by the payoff matrix below.

$(game_table([1 4; 3 2], [1 2; 3 2], ["U", "D"], ["L", "R"]))

> Hint: This game has a both pure strategy equilibria and a mixed strategy equilibrium. To find the mixed strategy equilibrium let the probability that player A uses strategy U be p and the probability that player B uses strategy L be q. As we learned in our analysis of matching pennies, if a player uses a mixed strategy (one that is not really just some pure strategy played with probability one) then the player must be indifferent between two pure strategies. That is the strategies must have equal expected payoffs. So, for example, if p is not 0 or 1 then it must be the case that q+4(1−q) = 3q+2(1−q) as these are the expected payoffs to player A from U and D when player B uses probability q.


"""

# ╔═╡ 93be7e24-5a47-482c-810e-bb86e6a277aa
md"""
# Q3 E&K exercise 6.10

In the payoff matrix below the rows correspond to player A’s strategies and the columns correspond to player B’s strategies. The first entry in each box is player A’s payoff and the second entry is player B’s payoff.

$(game_table([3 1; 2 3], [3 2; 1 0], ["U", "D"], ["L", "R"]))

**(a)** Find all pure strategy Nash equilibria of this game.

**(b)** Notice from the payoff matrix above that Player A’s payoff from the pair of strategies (U, L) is 3. Can you change player A’s payoff from this pair of strategies to some non-negative number in such a way that the resulting game has no pure-strategy Nash equilibrium? Give a brief (1-3 sentence) explanation for your answer.

> Note that in answering this question, you should only change Player A’s payoff for this one pair of strategies (U, L). In particular, leave the rest of the structure of the game unchanged: the players, their strategies, the payoff from strategies other than (U, L), and B’s payoff from (U, L).

**(c)** Now let’s go back to the original payoff matrix from part (a) and ask an analogous question about player B. So we’re back to the payoff matrix in which players A and B each get a payoff of 3 from the pair of strategies (U, L).

Can you change player B’s payoff from the pair of strategies (U, L) to some non- negative number in such a way that the resulting game has no pure-strategy Nash equilibrium? Give a brief (1-3 sentence) explanation for your answer.

> Again, in answering this question, you should only change Player B’s payoff for this one pair of strategies (U, L). In particular, leave the rest of the structure of the game unchanged: the players, their strategies, the payoff from strategies other than (U, L), and A’s payoff from (U, L).

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GameTheory = "64a4ffa8-f47c-4a47-8dad-aee7aadc3b51"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
GameTheory = "~0.1.0"
PlutoUI = "~0.7.15"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "d9352737cef8525944bf9ef34392d756321cbd54"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.38"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "61adeb0823084487000600ef8b1c00cc2474cd47"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.0"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "3533f5a691e60601fe60c90d8bc47a27aa2907ec"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.0"

[[Clp]]
deps = ["BinaryProvider", "CEnum", "Clp_jll", "Libdl", "MathOptInterface", "SparseArrays"]
git-tree-sha1 = "3df260c4a5764858f312ec2a17f5925624099f3a"
uuid = "e2554f3b-3117-50c0-817c-e040a3ddf72d"
version = "0.8.4"

[[Clp_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "MUMPS_seq_jll", "OpenBLAS32_jll", "Osi_jll", "Pkg"]
git-tree-sha1 = "5e4f9a825408dc6356e6bf1015e75d2b16250ec8"
uuid = "06985876-5285-5a41-9fcb-8948a742cc53"
version = "100.1700.600+0"

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[CoinUtils_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "9b4a8b1087376c56189d02c3c1a48a0bba098ec2"
uuid = "be027038-0da8-5614-b30d-e42594cb92df"
version = "2.11.4+2"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "1edc3eb6cd0ec2b5193ac6d37c1b1310044550fe"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.3"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "7220bc21c33e990c14f4a9a319b1d242ebc5b269"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.1"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "d249ebaa67716b39f91cf6052daf073634013c0f"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.23"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "8b3c09b56acaf3c0e581c66638b85c8650ee9dca"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.8.1"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "63777916efbcb0ab6173d09a658fb7f2783de485"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.21"

[[GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[GameTheory]]
deps = ["Clp", "Combinatorics", "LRSLib", "LightGraphs", "LinearAlgebra", "MathOptInterface", "Parameters", "Polyhedra", "QuantEcon", "Random"]
git-tree-sha1 = "21d56ebc9a41a410c9d2906a9f89c9cb7569e048"
uuid = "64a4ffa8-f47c-4a47-8dad-aee7aadc3b51"
version = "0.1.0"

[[GenericLinearAlgebra]]
deps = ["LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "ac44f4f51ffee9ff1ea50bd3fbb5677ea568d33d"
uuid = "14197337-ba66-59df-a3e3-ca00e7dcff7a"
version = "0.2.7"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

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

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

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

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "f0c6489b12d28fb4c2103073ec7452f3423bd308"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.1"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

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

[[JSONSchema]]
deps = ["HTTP", "JSON", "URIs"]
git-tree-sha1 = "2f49f7f86762a0fbbeef84912265a1ae61c4ef80"
uuid = "7d188eb4-7ad8-530c-ae41-71a32a6d4692"
version = "0.3.4"

[[JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "Printf", "Random", "SparseArrays", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "4358b7cbf2db36596bdbbe3becc6b9d87e4eb8f5"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "0.21.10"

[[LRSLib]]
deps = ["Libdl", "LinearAlgebra", "Markdown", "Polyhedra", "lrslib_jll"]
git-tree-sha1 = "c629c4f1c9471198819999f0c6f337146b21d7a7"
uuid = "262c1cb6-76e2-5873-868b-19ece3183cc5"
version = "0.7.2"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "6193c3815f13ba1b78a51ce391db8be016ae9214"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.4"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2dc1a9fc87e57e32b1fc186db78811157b30c118"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.0+5"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[MUMPS_seq_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "a1d469a2a0acbfe219ef9bdfedae97daacac5a0e"
uuid = "d7ed1dd3-d0ae-5e8e-bfb4-87a502085b8d"
version = "5.4.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "JSONSchema", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "575644e3c05b258250bb599e57cf73bbf1062901"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.9.22"

[[MathProgBase]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9abbe463a1e9fc507f12a69e7f29346c2cdc472c"
uuid = "fdba3010-5040-5b88-9595-932c9decdf73"
version = "0.7.8"

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

[[Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "8d9496b2339095901106961f44718920732616bb"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.22"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "144bab5b1443545bc4e791536c9f1eacb4eed06a"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.1"

[[NLopt]]
deps = ["MathOptInterface", "MathProgBase", "NLopt_jll"]
git-tree-sha1 = "d80cb3327d1aeef0f59eacf225e000f86e4eee0a"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "0.6.3"

[[NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2b597c46900f5f811bec31f0dcc88b45744a2a09"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.0+0"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS32_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ba4a8f683303c9082e84afba96f25af3c7fb2436"
uuid = "656ef2d0-ae68-5445-9ca0-591084a874a2"
version = "0.3.12+1"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Optim]]
deps = ["Compat", "FillArrays", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7863df65dbb2a0fa8f85fcaf0a41167640d2ebed"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.4.1"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Osi_jll]]
deps = ["Artifacts", "CoinUtils_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "6a9967c4394858f38b7fc49787b983ba3847e73d"
uuid = "7da25872-d9ce-5375-a4d3-7a845f58efdd"
version = "0.108.6+2"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "82041e63725d156bf61c6302dd7635ea13e3d5e7"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.2"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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
git-tree-sha1 = "615f3a1eff94add4bca9476ded096de60b46443b"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.17"

[[Polyhedra]]
deps = ["GenericLinearAlgebra", "GeometryBasics", "JuMP", "LinearAlgebra", "MutableArithmetics", "RecipesBase", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "ac8957775d8b45038b2a788ada92f94b5ae052f8"
uuid = "67491407-f73d-577b-9b50-8179a7c68029"
version = "0.6.17"

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "7499556d31417baeabaa55d266a449ffe4ec5a3e"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.17"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Primes]]
git-tree-sha1 = "afccf037da52fa596223e5a0e331ff752e0e845c"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[QuantEcon]]
deps = ["DSP", "DataStructures", "Distributions", "FFTW", "LightGraphs", "LinearAlgebra", "Markdown", "NLopt", "Optim", "Pkg", "Primes", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "Test"]
git-tree-sha1 = "d777434be1b3536821caea3fc5c4d9fd9d350c4f"
uuid = "fcd29c91-0bd7-5a09-975d-7ac3f643a60c"
version = "0.16.3"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

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

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "eb35dcc66558b2dda84079b9a1be17557d32091a"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.12"

[[StatsFuns]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "95072ef1a22b057b1e80f73c2a89ad238ae4cfff"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.12"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

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

[[TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

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

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[lrslib_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "de24a5e08e56a124508077e4bbaacd76a5bffe3e"
uuid = "3873f7d0-7b7c-52c3-bdf4-8ab39b8f337a"
version = "0.3.1+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─ee9d5f2e-21f4-11ec-1c1f-2976e41f30dc
# ╠═88ada2ea-42ea-4a2b-9aca-ddeff35d2238
# ╟─a450976f-9d82-40ce-aab0-5dd00813ba2a
# ╟─012f578e-d972-430a-b70f-599ce0399237
# ╟─3c31f151-6fd4-49e9-9878-a8f51b6294c5
# ╟─3a6c382b-c44b-4b04-b3a6-e2b8d5895a37
# ╠═a070ba38-3c92-4f8f-86dd-df81946fc707
# ╠═fffdf495-01ac-4982-ab5b-2e0af8bc5746
# ╠═87d5bd5f-3cdc-4312-98a5-0f9068f9d22d
# ╟─93be7e24-5a47-482c-810e-bb86e6a277aa
# ╟─da357997-6eb4-47a7-be59-cc0ceb15ca96
# ╠═59e89864-09d3-4b6b-b4d3-a627f75f0af4
# ╠═d8e712c0-3d9a-468b-ab05-3a860af5aaf3
# ╠═b32100f2-01bd-4294-92f2-7df05c56bee8
# ╠═d8bc5b05-c7b4-4a6e-bcbd-63b5d248340c
# ╠═ed296ca1-5ff8-4368-a171-9ce90462cde0
# ╟─4b1512ff-b2f4-4d08-8846-7db4639ec0ab
# ╠═61f7eb55-e6e5-4373-a87b-d0d66579cf4d
# ╠═676a76a5-d7b8-4335-9c28-467d670214a1
# ╠═44f1223d-0ae6-441b-ad4b-8c4c17902c1b
# ╟─c69d62c6-9faf-480f-b6df-47a807f529a5
# ╠═3b1a5c78-16e7-471b-876c-4dc52763e021
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
