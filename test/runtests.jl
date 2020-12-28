using AxisArrayConversion: to
using Test
import AxisKeys; const AK = AxisKeys
import AxisArrays; const AA = AxisArrays
import DimensionalData; const DD = DimensionalData

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
