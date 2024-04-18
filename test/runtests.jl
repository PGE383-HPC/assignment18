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
import assignment18
using Test

@testset "assignment18.jl" begin
    datafile = realpath(dirname(@__FILE__)*"/../data/data.csv")
    ans = assignment18.train(datafile)
    println(ans)
    @test all(isapprox.(ans, [2.367, 0.002], atol=0.01))
end
