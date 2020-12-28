module AxisArrayConversion
using Requires
export namedtuple, dimarray, axisarray, keyedarray

"""
    namedtuple(arr)::NamedTuple{(:axes, :values)}

Create a `NamedTuple` from an array `arr` with axis data.
"""
function namedtuple end

function namedaxes(o)
    return NamedTuple{axissymbols(o)}(axisvalues(o))
end
function namedaxes(o::NamedTuple)
    return o.axes
end
function values(o::NamedTuple)
    return o.values
end
function namedtuple(o)
    return (axes=namedaxes(o), values=values(o))
end

function dimarray(o)
    return dimarray(namedtuple(o))
end
function axisarray(o)
    return axisarray(namedtuple(o))
end
function keyedarray(o)
    return keyedarray(namedtuple(o))
end

function __init__()
    @require AxisArrays = "39de3d68-74b9-583c-8d2d-e117c070f3a9" include("AxisArrays.jl")
    @require AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"   include("AxisKeys.jl")
    @require DimensionalData = "0703355e-b756-11e9-17c0-8b28908087d0" include("DimensionalData.jl")

end

end
