
@hl type Person
    name::String
end
    
@hl type Developer <: Person
    salary::Int
end

@hl type SpecializedDeveloper <: Developer
    language::String
end

function sumsalaries(first::Developer, second::Developer)
    return first.salary + second.salary
end

@hl type Job
    nb_hours::Int
    assigned_dev::Developer
end

@concretify @hl type ConcreteJob
    nb_hours::Int
    assigned_dev::Developer
end
