workspace()

using HighLevelTypes, Base.Test

include("types.jl")

@testset "Basic Tests" begin

    bob = Developer("Bob", 10000)
    alice = SpecializedDeveloper("Alice", 15000, "Julia")
    
    shortjob = ConcreteJob(10,bob)
    @test_throws MethodError (longjob = ConcreteJob(100,alice)) 
    longjob = Job(100,alice)

    @test bob.name == "Bob"
    @test bob.salary == 10000
        
    @test alice.name == "Alice" 
    @test alice.salary == 15000    
    @test alice.language == "Julia"
        
    @test sumsalaries(bob, alice) == 25000
    @test shortjob.assigned_dev.name == "Bob"
    @test longjob.assigned_dev.name == "Alice"
    
end
