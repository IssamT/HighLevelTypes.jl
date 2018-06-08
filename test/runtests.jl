using HighLevelTypes, Base.Test

@hl type Person
    name::String
end
    
@hl type Developer{V} <: Person
    salary::V
end

@hl type SepecializedDeveloper <: Developer
    language::String
end

function sumsalaries(first::Developer, second::Developer)
    return first.salary + second.salary
end

@hl type Job
    nb_hours::Int
    assigned_dev::Developer
end

@testset "Basic Tests" begin

    bob = Developer("Bob", 10000)
    alice = SepecializedDeveloper("Alice", 15000, "Julia")
    shortjob = Job(10,bob)

    @test bob.name == "Bob"
    @test bob.salary == 10000
        
    @test alice.name == "Alice" 
    @test alice.salary == 15000    
    @test alice.language == "Julia"
        
    @test sumsalaries(bob, alice) == 25000
    @test shortjob.assigned_dev.name == "Bob"

end