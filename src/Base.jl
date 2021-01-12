################################################################################
##### Base.Array
################################################################################
function _collect(::Type{T}, arr::Array{T}) where {T}
    arr
end
function _collect(::Type{T}, arr::AbstractArray) where {T}
    collect(T, arr)
end
_collect(arr::Array) = arr
_collect(arr) = collect(arr)


function from_namedtuple(Arr::Type{<: Array{T}}, nt::NamedTuple) where {T}
    _collect(T, nt.values)::Arr
end

function from_namedtuple(Arr::Type{<: Array}, nt::NamedTuple)
    _collect(nt.values)::Arr
end

roottype(::Type{T}) where {T <: Array} = Array
