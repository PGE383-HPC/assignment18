# Homework Assignment 18

![Assignment 18](https://github.com/PGE383-HPC/assignment18-solution/actions/workflows/main.yml/badge.svg)

During a single-phase one-dimensional core flooding experiment, pressure readings were observed at 99 evenly spaced points in the interior of a core. The pressure as a function of $x$ observations are stored in the data file [data.csv](./data/data.csv') and shown in the figure below

[!img]("./images/data.png")

You job is find the unknown parameters $\theta_1$ and $\theta_2$ from a proposed mobility function of the form

$$
\lambda(x) = x^{\theta_1} + \theta_2
$$

You can use your [Gripap.jl](https://gridap.github.io/Gridap.jl/stable/) finite element solution from [Assignment 17](https://github.com/PGE383-HPC/assignment17)) to solve the forward problem.

A useful package for solving the inverse problem is [Optimisers.jl](https://fluxml.ai/Optimisers.jl/dev/).  You'll need to be able to compute the gradient of a loss function with respect to the unknown parameters $\theta_1$ and $\theta_2$.  Unfortunately, you cannot (currently) use automatic differentiation with Gridap; however, you can always use finite difference approximations to compute gradients.  A nice package for computing finite differences in Julia is [FiniteDifferences.jl](https://juliadiff.org/FiniteDifferences.jl/latest/).


## Testing

To see if your answer is correct, run the following command at the Terminal
command line from the repository's root directory

```bash
julia --project=. -e "using Pkg; Pkg.test()"
```

the tests will run and report if passing or failing.
