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

# ╔═╡ 958b706c-29b6-474a-9c60-ad0e65e81f9b
using Agents

# ╔═╡ 1362e871-05b4-4089-bb19-4f1c4f2864cc
using Distributions

# ╔═╡ ea43940d-4b84-4913-be9b-a3c5b2e1be99
using PlotlyBase, DataFrames

# ╔═╡ 0286f290-aee8-4541-8c8f-0edb37d367bc
using PlutoUI

# ╔═╡ ee9d5f2e-21f4-11ec-1c1f-2976e41f30dc
md"""
# Agent Based Models Practice

> Computational Analysis of Social Complexity
>
> Fall 2021, Spencer Lyon


In this assignment we will study how ties in a social network can influence decision making via an agent based model.

The assignment is worth 100 points. Each of the 10 questions is worth 10 points.

**References**

- Class notes
- Agents.jl documentation
"""

# ╔═╡ 0e8d81f6-1d7e-422a-9fa4-beb0060c2c6c
md"""
## Model Description

In this assignment we'll study how ties in a social network can influence decision making.

Suppose we have N agents, each of whom is deciding whether or not to purchase a new cell phone. 

Each agent lives at a specific location in a periodic continuous two-dimensional space of size (315, 315). The fact that it is periodic means that 314.5 + 1 == 0.5. These two dimensions could represent geographic location, spectrum of beliefs, or anything else. Consider it an [embedding](https://www.pinecone.io/learn/vector-embeddings/) of that agent's social presence into two dimensions.

There are 5 different types of agents. Each type of agent has a specific type radius of influence and purchasing behavior. These features (as well as % of population of each agent type) are summarized in the table below

| Type | % of population | radius of influence | purchase behavior |
| ---- | --------------- | ------------------- | ----------------- |
| influencers | 2.5% | 30 | always buy immediately |
| early adopters | 13.5% | 20 | buy if at least one social connection has bought |
| early majority | 34% | 15 | buy if at least two social connections have bought |
| late majority | 34% | 10 | buy if at least 1/2 their connections have bought | 
| laggards | 16% | 10 | buy only when all other connections have bought |

The purchasing behavior dictates the **rules** an agent follows when deciding whether or not to purchase a phone on each time step

The radius of influence dictates which edges form in a directed graph. If agent $i$ has a radius of influence equal to $r_i$, then we would say an edge is formed between all agents $j$ for which $\ell^2(\text{location}_i - \text{location}_j) <= r_i$, where $\ell^2$ represents the [l2 (or Euclidean) norm](https://mathworld.wolfram.com/L2-Norm.html). Note that if $r_i > r_j$ it might be the case that an edge is formed between from $i => j$, but not the other way around.

Finally, we'll assume that all early adopters have "social drift". This means that they move through the space at a constant velocity. This means that the connections between agents need to be re-computed on each time step because the position of 13.5% of the agents will have changed.
"""

# ╔═╡ ad65da64-f50a-4908-8bcf-a27d9bb1f56e
md"""
### Q1

Your first task is to provide a precise conceptual/mathematical description of an agent based model that is consistent with the description above. Be sure to clearly define agents (including state variables), environment, and rules.

Be precise.
"""

# ╔═╡ 2846dafb-975d-4101-9ffd-4f6c248ab5b5
md"""
**Proposed Solution**

- Environment: 2-dimensional continuous, periodic space spanning $[0, 315] \times [0, 315]$
- Agents:
  - Agents are all consumers
  - There are 5 types of agents: influencers (I), early adopters (EA), early majority (EM), late majority (LM), and laggards (L)
  - Each agent has as state:
    - id: integer unique to each agent
    - pos: tuple of 2 Float64 values indicating current position in environment
    - vel: tuple of 2 Float64 values indicating the current velocity in each dimension
    - type: one of I, EA, EM, LM, and L. This is constant over time
    - radius_of_influence: a type-dependant constant that dictates which other agents can influence the agent. This is also fixed over time
    - has_purchased: a boolean indicating if the agent has already purchased the new phone
- Rules: there are two flavor of rules
  1. Movement rules: agents that are social drifters have a non-zero veloicty. Their position updates each period to be `agent.pos = (agent.pos[1] + agent.vel[1], agent.pos[2] + agent.vel[2])`
  2. Purchasing rules: an agent that has not yet purchased the phone will first observe the purchase status of all current social connections (given all agents' positions and the specific agent's radius of influence). Then, they will choose to purchase or not based on the rules in the last column of the table above (not repeated here for brevity).
"""

# ╔═╡ 09dd7f28-6d3f-4c1c-94a3-f3de0c9d5869
md"""
## Q2

We will now turn to code

Below you will see that we have defined an `Enum` for the consumer type

In Julia, enums are a special kind of type that is only allowed to take on one of a fixed set of values. Given that we have a fixed set of ConsumerTypes, an enum is a great choice for this setting.
"""

# ╔═╡ 62842425-25d7-41e5-b52a-aa099cf42183
@enum ConsumerType begin
	influencer
	early_adopter
	early_majority
	late_majority
	laggard
end

# ╔═╡ 3c51d400-0e46-410b-85ae-934d0f966fcf
md"""
Note that after defining the enum we can access `influencer`, `laggard`, and other `ConsumerTypes` just by typing their names as shown below:
"""

# ╔═╡ d6e19434-b894-4400-81be-519028d3302f
influencer

# ╔═╡ 33883be5-f02a-4c41-b165-4e0181ad9307
laggard

# ╔═╡ b83321dc-eaf3-4243-8cc8-1f362c24f5ab
md"""
Your task for Q2 is to fix the definition of `Base.rand(::Type{ConsumerType})` below so that it will return the consumer type according to the distribution in the table above.

> HINT: you might find the `Categorical` distribution from Distributions.jl helpful

> NOTE: the syntax `Base.` in `Base.rand` is required here because we are adding a method to an existing function from a different module (`Base` is module name).

> NOTE: the `::Type{ConsumerType}` syntax lets us call our `rand` method using the name of the type `ConsumerType` instead of a value of `ConsumerType` (like `early_adopter` or `late_majority`). See below the code you are supposed to fix for an example of how we can use it.
"""

# ╔═╡ 49bcf734-ad49-4f2d-bfa7-a86319341cf4
function Base.rand(::Type{ConsumerType})
	probs = [0.025, 0.135, 0.34, 0.34, 0.16]
	dist = Categorical(probs)
	ConsumerType(rand(dist)-1)
end

# ╔═╡ e5c4a18a-5c69-461a-b42a-6925233a9240
rand(ConsumerType)

# ╔═╡ 927a8f08-f6ea-4c13-8bc6-685492625f1d
md"""
## Q3

Create the appropriate environment (or `space` in Agents.jl language) for the ABM
"""

# ╔═╡ 0c10a5e1-587c-4acd-9fd7-76821f3b81a0
# TODO: change this line to give the correct space
space = ContinuousSpace((315, 315), periodic=true)

# ╔═╡ 4c0e292a-686b-4987-8d07-6ebfdc7c9e8c
md"""
## Q4

Fill in the code below to create an `AbstractAgent` subtype called `SocialConsumer`

Note that the `@agent XXX ContinuousAgent{2} begin` part of of the code is equivalent to writing:

```julia
mutable struct XXX <: AbstractAgent
    id::Int
    pos::Tuple{Float64,Float64}
    vel::Tuple{Float64,Float64}
```

In other words, it is a shorthand for creating the necessary fields Agents.jl expects all `AbstractAgent` subtypes to have for agents that live in a continuous space

In between the `begin` and `end` you need to add any additional fields necessary for representing the state of the agent. Refer back to your answer to Q1 for what fields this type should have.

> NOTE: as we'll see below, the `pos` field represents current position and `vel` represents velocity
"""

# ╔═╡ 6b2d868c-468c-47a8-8403-78ebef13beed
@agent SocialConsumer ContinuousAgent{2} begin
	ctype::ConsumerType
	has_purchased::Bool
end

# ╔═╡ 7f91d373-fd04-4811-8705-892d7f7fcb3d
md"""
## Q5

Define a function that can create an `AgentBasedModel` with N `SocialConsumer` agents in the `space` defined earlier

The `ConsumerType` of these agents should follow the outlined distribution

Make sure to set `vel` equal to 0 for all agents, except the `early_adopter`s. For `early_adopter` agent types, set the `vel` equal to a tuple of two random numbers between 0 and `v`

> HINT: the method `add_agent!(agent, model)` will place the agent randomly in the space.  
"""

# ╔═╡ 08582b31-a545-4bb1-8b1b-f3722c610374
function create_model(;N::Int=1000, v::Float64=15.0)
	# Step 1: create the model
	model = AgentBasedModel(SocialConsumer, space)
	
	# Step 2: loop from 1:N to create agents
	for i in 1:N
		ctype = rand(ConsumerType)
		vel = ctype == early_adopter ? (v*rand(), v*rand()) : (0, 0)
		has_purchased = ctype == influencer
		agent = SocialConsumer(i, (0, 0), vel, ctype, has_purchased)
		add_agent!(agent, model)
	end
	# step 3: return the model
	model
end

# ╔═╡ 0256b6a9-ed8b-4974-89e2-1e4b59c9deec
model = create_model()

# ╔═╡ 00dc16b6-2571-429d-b326-7e629096d955
md"""
## Q6

Define the `agent_step!` function below

Refer to your description of the rules from Q1 for assistance in this part.

> HINT: Look for a method of [`nearby_agents`](https://juliadynamics.github.io/Agents.jl/stable/api/#Agents.nearby_agents) that will allow you to consider a "radius". Use the radius of influence for the agent. for this argument.
	
"""

# ╔═╡ 45bc0bf0-59eb-4caf-b214-57dc890461eb
const radii = Dict(
	influencer => 30, 
	early_adopter => 20, 
	early_majority => 15, 
	late_majority => 10, 
	laggard => 10
)

# ╔═╡ fbe7d0d5-53ff-4789-8f13-4122af1ad770
aa = model.agents[1]

# ╔═╡ 08bce0eb-a404-4ad1-861d-713af3a59eae
@inline function should_purchase(
		a::SocialConsumer, n_connections::Int, n_connections_purchased::Int
	)
	if a.ctype == laggard
		return n_connections == n_connections_purchased
	elseif a.ctype == late_majority
		return (n_connections_purchased / n_connections) >= 0.5
	elseif a.ctype == early_majority
		return n_connections_purchased >= 2
	elseif a.ctype == early_adopter
		return n_connections_purchased >= 1
	else
		return true
	end
end

# ╔═╡ 0ad743f6-20b5-47a0-a244-01e47c040770
function count_neighbors(agent, model)
	# initialize counters for number of connections and those that have
		# purchased already
		n_connections = 0
		n_connections_purchased = 0
		
		# now search over all connections
		# nearby_agents will use l2 norm by default ;)
		for connection in nearby_agents(agent, model, radii[agent.ctype])
			# increment counters appropriately
			n_connections += 1
			if connection.has_purchased
				n_connections_purchased += 1
			end
		end
	return n_connections, n_connections_purchased
end

# ╔═╡ 097a5d62-c1b1-4131-9339-0a3915dd3e9c
function agent_step!(agent::SocialConsumer, model)
	# first apply purchase rule
	if !agent.has_purchased
		# count number of neighbors and # neighbors that purchased
		n, n_purchased = count_neighbors(agent, model)
		
		# apply rule based on agent type
		agent.has_purchased = should_purchase(agent, n, n_purchased)
	end
	
	# now apply movement rule
	if any(x -> x != 0, agent.vel)
		move_agent!(agent, model)
	end
end

# ╔═╡ 0a246c95-8a16-4a77-bb64-54ed5f56488f
md"""
## Q7

Simulate the model for 100 time steps

After simulating, construct a line graph with the time step on the  horizontal axis and the number of agents that have purchased the phone on the vertical axis.

Construct the plot in a function so you can reuse it later in the assignment.
"""

# ╔═╡ 9cfe0b6f-73ef-4ace-846d-97d808be8a09
function run_model(; N=1000, v=15.0)
	model = create_model(N=N, v=v)
	data, _ = run!(model, agent_step!, 100, adata=[:ctype, :has_purchased, :pos])
	data
end

# ╔═╡ 5cdb4399-c853-4357-80a6-aa6c1da8b871
data = run_model();

# ╔═╡ 6035f555-a223-4a1e-835c-4572df938467
function plot_n_purchased(sim_data::DataFrame; gb=:step, func=count, kw...)
	plot_data = combine(groupby(sim_data, gb), :has_purchased => func)
	col = Symbol("has_purchased_", func)
	Plot(
		plot_data, 
		Layout(width=800, height=450, margin_r=350); 
		x=:step, y=col, kw...
	)
end

# ╔═╡ fba49a39-dba4-4d30-89de-d17045811bd4
plot_n_purchased(data)

# ╔═╡ 0bbd6346-0198-4e02-9051-82a3cd3bc850
md"""
## Q8

Repeat the analysis in question 7, but construct one line per `ConsumerType`. You should have a single set if x/y axes and 5 lines on that chart.

You do not need to re-simulate the model -- you can reuse the DataFrame you obtained in Q7.

Do any results surprise you? Explain.
"""

# ╔═╡ e5f581b1-6818-458f-bb05-8624f4be0b27
plot_n_purchased(data; gb=[:step, :ctype], color=:ctype)

# ╔═╡ 34d4fee4-d4c7-4337-aa9e-d37dfec9d1ae
md"""
Results are not surprising. We see no laggards purchasing. It would be more telling to plot the percent of each type that has purchased over time. We do that below
"""

# ╔═╡ 7ba828b8-1308-4d01-a6d7-78ffa07b03fd
plot_n_purchased(data; gb=[:step, :ctype], color=:ctype, func=mean)

# ╔═╡ aefc858c-3ae7-4e6e-80f0-f09eddb5120f
md"""
## Q9

Repeat the analysis in Q8, but this time for a model where `v` is equal to 30. What is different about these results?

"""

# ╔═╡ 774a777d-5dfa-41d0-9001-b2f9c814c053
data_30 = run_model(v=30.0);

# ╔═╡ ea0a1ac1-c1ba-4501-b2be-8e8c6dc96057
plot_n_purchased(data_30; gb=[:step, :ctype], color=:ctype, func=mean)

# ╔═╡ 5558eb9d-d2fc-4b50-b0b8-cacc1fe78bd0
plot_n_purchased(data_30)

# ╔═╡ 7c890e41-4f55-4eed-b575-49b616541093
md"""
Almost identical results
"""

# ╔═╡ 8c3e36ec-a752-4b3e-a529-538c2fdb24e9
md"""
## Q10

Repeat the analysis in Q8, but this time set `v=0`. What is different about these results?

To help your discussion choose one other type of chart (not a line or bar chart) that helps you make your point.
"""

# ╔═╡ 71d97f33-a5ee-47f5-ac2a-b052c21bcfc3
data_0 = run_model(v=0.0);

# ╔═╡ 76935831-d4e1-419c-ba22-661f87b149ee
plot_n_purchased(data_30)

# ╔═╡ 0bf1bfd5-3680-448c-b0be-ef29203dd636
plot_n_purchased(data_30; gb=[:step, :ctype], color=:ctype, func=mean)

# ╔═╡ a16d31f6-36eb-47af-bc4d-cab283af6639
md"""
Same results again. It appears that social drift does not matter so much in this model.

What would make an impact would be to alter the rules to help laggards purchase more and slow down purchasing for other types. Some various adjustments that would be worth studying are:

1. Decrease the radius of influence for all types
2. Have laggards purchase when all non-laggard connections have purchased

"""

# ╔═╡ 35a2c38f-b5e8-4c97-bdb5-28788ece3ad4
md"""
The question asked for another type of plot. Here is a scatter chart showing where agents are positioned and whether or not they have purchased the good. Use the slider to change which step is shown.
"""

# ╔═╡ 7b0f9355-3926-4d89-9cb3-14b0478d7f58
@bind step_number Slider(0:10, show_value=true)

# ╔═╡ a26855f7-d770-4837-a2b2-b4196738c830
function heatmap_for_step(sim_data, step)
	sub = sim_data[sim_data.step .== step, :]
	xs = first.(sub.pos)
	ys = last.(sub.pos)
	purchased = sub.has_purchased
	colors = map(x -> x ? :green : :red, purchased)
	Plot(
		scatter(x=xs, y=ys, marker_color=colors, mode=:markers),
		Layout(
			width=800, height=450, 
			xaxis_range=(-5, 355), yaxis_range=(-5, 355),
			title_text="Purchased status on step $(step)"
		)
	)
end

# ╔═╡ 593d6927-a15c-4ebb-9b29-e04ab9057668
heatmap_for_step(data_0, step_number)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Agents = "46ada45e-f475-11e8-01d0-f70cc89e6671"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Agents = "~4.5.6"
DataFrames = "~1.2.2"
Distributions = "~0.25.23"
PlotlyBase = "~0.8.18"
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[Agents]]
deps = ["CSV", "DataFrames", "DataStructures", "Distributed", "GraphRecipes", "JLD2", "LightGraphs", "LinearAlgebra", "OpenStreetMapX", "ProgressMeter", "Random", "RecipesBase", "Requires", "Scratch", "StatsBase"]
git-tree-sha1 = "628c5b7e7b2fb0fc724e10c6e91f06750befbed2"
uuid = "46ada45e-f475-11e8-01d0-f70cc89e6671"
version = "4.5.6"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "74e8234fb738c45e2af55fdbcd9bfbe00c2446fa"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.8.0"

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
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

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

[[Distributions]]
deps = ["ChainRulesCore", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "d249ebaa67716b39f91cf6052daf073634013c0f"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.23"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "3c041d2ac0a52a12a27af2782b34900d9c3ee68c"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.1"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

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

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[GeometryTypes]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "07194161fe4e181c6bf51ef2e329ec4e7d050fc4"
uuid = "4d00f742-c7ba-57c2-abde-4428a4b178cb"
version = "0.8.4"

[[GraphRecipes]]
deps = ["AbstractTrees", "GeometryTypes", "InteractiveUtils", "Interpolations", "LightGraphs", "LinearAlgebra", "NaNMath", "NetworkLayout", "PlotUtils", "RecipesBase", "SparseArrays", "Statistics"]
git-tree-sha1 = "7269dc06b8cd8d16fc2b1756cf7f41901bbc3c52"
uuid = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
version = "0.5.7"

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

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "61aa005707ea2cebf47c8d780da8dc9bc4e0c512"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.4"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

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

[[JLD2]]
deps = ["DataStructures", "FileIO", "MacroTools", "Mmap", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "46b7834ec8165c541b0b5d1c8ba63ec940723ffb"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.15"

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
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibExpat]]
deps = ["Expat_jll", "Pkg"]
git-tree-sha1 = "27dc51f94ceb107fd53b367431a638b430e01e81"
uuid = "522f3ed2-3f36-55e3-b6df-e94fee9b0c07"
version = "0.6.1"

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

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "34dc30f868e368f8a17b728a1238f3fcda43931a"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.3"

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

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "SparseArrays"]
git-tree-sha1 = "8daa46f6e2c2eb41d94d2746823a9262351d75b5"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c0e9e582987d36d5a61e650e6e543b9e44d9914b"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.7"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OpenStreetMapX]]
deps = ["CodecZlib", "DataStructures", "HTTP", "JSON", "LibExpat", "LightGraphs", "ProtoBuf", "Random", "Serialization", "SparseArrays", "StableRNGs", "Statistics"]
git-tree-sha1 = "3b2496e723fa8b5220e4154b10b215419afc93dd"
uuid = "86cd37e6-c0ff-550b-95fe-21d72c8d4fc9"
version = "0.2.5"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "bfd7d8c7fd87f04543810d9cbd3995972236ba1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

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

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "69fd065725ee69950f3f58eceb6d144ce32d627d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[ProtoBuf]]
deps = ["Logging", "protoc_jll"]
git-tree-sha1 = "37585d8c037352f23dce4b5bb9c2de2a17a76b71"
uuid = "3349acd9-ac6a-5e09-bcdb-63829b23a429"
version = "0.11.3"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "01d341f502250e81f6fec0afe662aa861392a3aa"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.2"

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

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "54f37736d8934a12a200edea2f9206b03bdf3159"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.7"

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

[[StableRNGs]]
deps = ["Random", "Test"]
git-tree-sha1 = "3be7d49667040add7ee151fefaf1f8c04c8c8276"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.0"

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
git-tree-sha1 = "65fb73045d0e9aaa39ea9a29a5e7506d9ef6511f"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.11"

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

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9398e8fefd83bde121d5127114bd3b6762c764a6"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.4"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[protoc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "89b92b537ffde09cab61ad20636da135d0791007"
uuid = "c7845625-083e-5bbe-8504-b32d602b7110"
version = "3.15.6+0"
"""

# ╔═╡ Cell order:
# ╟─ee9d5f2e-21f4-11ec-1c1f-2976e41f30dc
# ╠═958b706c-29b6-474a-9c60-ad0e65e81f9b
# ╟─0e8d81f6-1d7e-422a-9fa4-beb0060c2c6c
# ╟─ad65da64-f50a-4908-8bcf-a27d9bb1f56e
# ╟─2846dafb-975d-4101-9ffd-4f6c248ab5b5
# ╟─09dd7f28-6d3f-4c1c-94a3-f3de0c9d5869
# ╠═62842425-25d7-41e5-b52a-aa099cf42183
# ╟─3c51d400-0e46-410b-85ae-934d0f966fcf
# ╠═d6e19434-b894-4400-81be-519028d3302f
# ╠═33883be5-f02a-4c41-b165-4e0181ad9307
# ╟─b83321dc-eaf3-4243-8cc8-1f362c24f5ab
# ╠═1362e871-05b4-4089-bb19-4f1c4f2864cc
# ╠═49bcf734-ad49-4f2d-bfa7-a86319341cf4
# ╠═e5c4a18a-5c69-461a-b42a-6925233a9240
# ╟─927a8f08-f6ea-4c13-8bc6-685492625f1d
# ╠═0c10a5e1-587c-4acd-9fd7-76821f3b81a0
# ╟─4c0e292a-686b-4987-8d07-6ebfdc7c9e8c
# ╠═6b2d868c-468c-47a8-8403-78ebef13beed
# ╟─7f91d373-fd04-4811-8705-892d7f7fcb3d
# ╠═08582b31-a545-4bb1-8b1b-f3722c610374
# ╠═0256b6a9-ed8b-4974-89e2-1e4b59c9deec
# ╟─00dc16b6-2571-429d-b326-7e629096d955
# ╠═45bc0bf0-59eb-4caf-b214-57dc890461eb
# ╠═fbe7d0d5-53ff-4789-8f13-4122af1ad770
# ╠═08bce0eb-a404-4ad1-861d-713af3a59eae
# ╠═0ad743f6-20b5-47a0-a244-01e47c040770
# ╠═097a5d62-c1b1-4131-9339-0a3915dd3e9c
# ╟─0a246c95-8a16-4a77-bb64-54ed5f56488f
# ╠═9cfe0b6f-73ef-4ace-846d-97d808be8a09
# ╠═5cdb4399-c853-4357-80a6-aa6c1da8b871
# ╠═ea43940d-4b84-4913-be9b-a3c5b2e1be99
# ╠═6035f555-a223-4a1e-835c-4572df938467
# ╠═fba49a39-dba4-4d30-89de-d17045811bd4
# ╟─0bbd6346-0198-4e02-9051-82a3cd3bc850
# ╠═e5f581b1-6818-458f-bb05-8624f4be0b27
# ╟─34d4fee4-d4c7-4337-aa9e-d37dfec9d1ae
# ╠═7ba828b8-1308-4d01-a6d7-78ffa07b03fd
# ╟─aefc858c-3ae7-4e6e-80f0-f09eddb5120f
# ╠═774a777d-5dfa-41d0-9001-b2f9c814c053
# ╠═ea0a1ac1-c1ba-4501-b2be-8e8c6dc96057
# ╠═5558eb9d-d2fc-4b50-b0b8-cacc1fe78bd0
# ╠═7c890e41-4f55-4eed-b575-49b616541093
# ╟─8c3e36ec-a752-4b3e-a529-538c2fdb24e9
# ╠═71d97f33-a5ee-47f5-ac2a-b052c21bcfc3
# ╠═76935831-d4e1-419c-ba22-661f87b149ee
# ╠═0bf1bfd5-3680-448c-b0be-ef29203dd636
# ╟─a16d31f6-36eb-47af-bc4d-cab283af6639
# ╟─35a2c38f-b5e8-4c97-bdb5-28788ece3ad4
# ╟─0286f290-aee8-4541-8c8f-0edb37d367bc
# ╟─7b0f9355-3926-4d89-9cb3-14b0478d7f58
# ╟─a26855f7-d770-4837-a2b2-b4196738c830
# ╟─593d6927-a15c-4ebb-9b29-e04ab9057668
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
