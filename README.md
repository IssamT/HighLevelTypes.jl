# HighLevelTypes

The goal of HighLevelTypes.jl is to relieve the user from having to answer the question that we often face. Should this be a concrete or abstract type? This question is important because both have their own limitations.

- **For concrete types:** Any behavior defined using concrete types can not be inherited.  Sometimes you even don't know whether you will have in the future a specialization of your type or not. Take for example the case of Diagonal matrices defined [here](https://github.com/JuliaLang/julia/blob/0d7248e2ff65bd6886ba3f003bf5aeab929edab5/base/linalg/diagonal.jl). Assume someone works with diagonal matrices such that all elements of a matrix are taking only 3 values. It is natural to create a new type that additionally stores those values. But since all the functions were defined for the concrete type `Diagonal`, it is not possible to reuse this behavior. And as you know, inheriting behavior is much more important than inheriting fields.

- **For abstract types:** If there is a field that would naturally fit in the abstract type, its definition needs to be delayed until the definition of the concrete types. This second issue is probably less important than the first one, although for some cases it makes the code really awkward.

As a high level language, Julia deserves a high level type. doesn't it? 

## What is a high level type ?

A high level type is an abstraction for two underlying types: one is abstract and one is concrete. The user only defines high level types. Automatically, Function arguments will be using the abstract types, while field types and instantiations will use the concrete types.

```julia
@hl type Person
    name::String
end
    
@hl type Developer <: Person
    salary::Int32
end

@hl type SepecializedDeveloper <: Developer
    language::String
end

function sumsalaries(first::Developer, second::Developer)
    return first.salary + second.salary
end

bob = Developer("Bob", 10000)
bob.name #returns "Bob" 
bob.salary #returns 10000

alice = SepecializedDeveloper("Alice", 15000, "Julia")    
alice.name # returns "Alice" 
alice.salary # returns 15000    
alice.language # returns "Julia"
    
sumsalaries(bob, alice) #returns 25000
```

## How does this work on the low level?

An abstract type may have a set of attributes attached to it. Every time an abstract type is defined a concrete type is also defined. The latter includes all fields that were attached to the abstract type or any of its parents.

The code of this package is highly inspired by ConcreteAbstractions.jl