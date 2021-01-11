using AxisArrayConversion: to
using Test
import AxisKeys; const AK = AxisKeys
import AxisArrays; const AA = AxisArrays
import DimensionalData; const DD = DimensionalData

@testset "Array" begin

    @testset "Vector" begin
        vec = [1,2,3]
        nt = @inferred to(NamedTuple, vec)
        @test propertynames(nt) === (:axes, :values)
        @test nt.values === vec
        @test nt.axes   === (x1 = axes(vec,1),)
        vec2 = @inferred to(Array, nt)
        @test vec2 === vec
        vec3 = @inferred to(Vector{Int}, nt)
        @test vec3 === vec
        vec_f64 = @inferred to(Array{Float64}, nt)
        @test vec_f64 == vec
        @test typeof(vec_f64) === Vector{Float64}
    end

    @testset "Matrix" begin
        mat = rand(Int, (2,3))

        nt = @inferred to(NamedTuple, mat)
        @test nt === (
            axes = NamedTuple{(:x1, :x2)}(axes(mat)),
            values = mat
        )
        @test @inferred(to(Matrix, nt)) === mat
        @test @inferred(to(Array,  nt)) === mat
    end

    @testset "lax conversion" begin
        # we might want to disable lax conversion by default?
        nt = (axes=(a=[2,3,4],), values=[1,2,3])
        @test to(Vector, nt) === nt.values

        ka::AK.KeyedArray = to(AK.KeyedArray, nt)
        @test to(Vector, ka) === nt.values

    end
end

@testset "to" begin
    axs = (a=1:2, b=[10,20, 30])
    nt = (axes=axs, values=(randn(2,3)))
    @test nt === to(NamedTuple, nt)

    aa = to(AA.AxisArray, nt)
    @test aa isa AA.AxisArray

    da = to(DD.DimArray, nt)
    @test da isa DD.DimArray

    ka = to(AK.KeyedArray, nt)
    @test ka isa AK.KeyedArray

    @test aa == to(AA.AxisArray, aa)
    @test aa == to(AA.AxisArray, da)
    @test aa == to(AA.AxisArray, ka)
    @test aa == to(AA.AxisArray, nt)

    @test da == to(DD.DimArray, aa)
    @test da == to(DD.DimArray, da)
    @test da == to(DD.DimArray, ka)
    @test da == to(DD.DimArray, nt)

    @test ka == to(AK.KeyedArray, aa)
    @test ka == to(AK.KeyedArray, da)
    @test ka == to(AK.KeyedArray, ka)
    @test ka == to(AK.KeyedArray, nt)

    @test nt == to(NamedTuple, aa)
    @test nt == to(NamedTuple, da)
    @test nt == to(NamedTuple, ka)
    @test nt == to(NamedTuple, nt)

    @inferred to(NamedTuple, aa)
    @inferred to(NamedTuple, da)
    @inferred to(NamedTuple, ka)
    @inferred to(NamedTuple, nt)

    arrs = [aa, da, ka, nt]
    for a1 in arrs
        for a2 in arrs
            T = typeof(a1)
            b1 = to(T, a2)
            @test b1 isa T
            @test b1 == a1

            @inferred to(T, a2)
            # try
            #     @inferred to(T, a2)
            # catch err
            #     @warn """Inference of `to(T, o)` broken for
            #     T = $T
            #     typeof(o) = $(typeof(o))
            #     """
            # end
        end
    end
end
