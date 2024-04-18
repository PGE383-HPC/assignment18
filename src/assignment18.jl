#!/usr/bin/env julia

# Copyright 2022 John T. Foster
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module assignment18

using Gridap
using Plots
using Optimisers
using FiniteDifferences
using Lux
using CSV
using Tables

function fe_solver(number_of_elements::Integer, 
                   λ::Function=(x) -> x[1] ^ 3 + 0.001, 
                   left_bc::Real=15.0, 
                   right_bc::Real=5.0)
    
    # Discretization
    n = number_of_elements 
    domain = (0,1)
    partition = (n,)
    model = CartesianDiscreteModel(domain, partition)
    
    # Reference FE
    reffe = ReferenceFE(lagrangian, Float64, 1)
    
    # Test and trial spaces
    δp = TestFESpace(model, reffe; 
                     conformity=:H1, 
                     dirichlet_tags=["tag_1", "tag_2"])

    p = TrialFESpace(δp, [x -> left_bc, x -> right_bc])
    
    # Quadrature
    degree = 2
    Ω = Triangulation(model)
    dΩ = Measure(Ω, degree)
    
    # Bilinear form
    x = get_physical_coordinate(Ω)
    a(p, δp) = ∫(λ∘(x) * ∇(p)⋅∇(δp) ) * dΩ
    b(δp) = 0.0

    # Assemble the linear problem
    op = AffineFEOperator(a, b , p, δp)
    
    # Solve
    ls = LUSolver()
    solver = LinearFESolver(ls)
    ph = solve(solver, op)
    ph 
end

function generate_reference_data()
    sol = fe_solver(100)
    sol.free_values
end

function plot_reference_data()
    sol = fe_solver(100)
    x = getindex.(sol.cell_field.trian.grid.node_coords, 1) 
    plot(x[2:end-1], sol.free_values .+ rand(length(sol.free_values)) .* 0.5, marker=2)
end

function write_reference_data()
    sol = fe_solver(100)
    x = getindex.(sol.cell_field.trian.grid.node_coords, 1) 
    CSV.write("data.csv", Tables.table(hcat(x[2:end-1], (sol.free_values .+ rand(length(sol.free_values)) .* 0.5))), writeheader=false)
end

function read_data(filename)
    CSV.File(filename, header=false) |> Tables.matrix
end

function plot_data(filename)
    data = read_data(filename)
    plot(data[:, 1], data[:, 2], seriestype=:scatter, xlabel="t", ylabel="p", label="data")
end

function λ(x, θ)
    x[1] ^ θ[1]  +  θ[2]
end

function predict(θ)
    fe_solver(100,x -> λ(x, θ)).free_values
end

loss(θ, data) = sum(abs2, predict(θ) - data)

function train(filename::String, nepochs::Integer=5000, tolerance::Real= 5, θ::Vector{<:Real}=[1.0, 0.1])
    ###########################
    ###### ADD CODE HERE ######
    ###########################
    θ # Return the optimized parameters
end

function plot_data_and_prediction(θ, filename)
    sol = fe_solver(100, x -> λ(x, θ))
    x = getindex.(sol.cell_field.trian.grid.node_coords, 1) 
    plot_data(filename)
    plot!(x[2:end-1], sol.free_values, label="prediction")
end


export fe_solver, train

end

