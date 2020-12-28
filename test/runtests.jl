using AxisArrayConversion
using Test
import AxisKeys; const AK = AxisKeys
import AxisArrays; const AA = AxisArrays
import DimensionalData; const DD = DimensionalData
using AxisArrayConversion: axisarray, keyedarray, dimarray, namedtuple

@testset "conversion" begin
    axs = (a=1:2, b=[10,20, 30])
    nt = (axes=axs, values=(randn(2,3)))
    @test nt === namedtuple(nt)

    aa = axisarray(nt)
    @test aa isa AA.AxisArray

    da = dimarray(nt)
    @test da isa DD.DimArray

    ka = keyedarray(nt)
    @test ka isa AK.KeyedArray

    @test aa == axisarray(aa)
    @test aa == axisarray(da)
    @test aa == axisarray(ka)
    @test aa == axisarray(nt)

    @test da == dimarray(aa)
    @test da == dimarray(da)
    @test da == dimarray(ka)
    @test da == dimarray(nt)

    @test ka == keyedarray(aa)
    @test ka == keyedarray(da)
    @test ka == keyedarray(ka)
    @test ka == keyedarray(nt)

    @test nt == namedtuple(aa)
    @test nt == namedtuple(da)
    @test nt == namedtuple(ka)
    @test nt == namedtuple(nt)

    @inferred namedtuple(aa)
    @inferred namedtuple(da)
    @inferred namedtuple(ka)
    @inferred namedtuple(nt)

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
