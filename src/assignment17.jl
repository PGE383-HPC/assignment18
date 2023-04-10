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
module assignment17

using Gridap
using Plots

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


export fe_solver

end

