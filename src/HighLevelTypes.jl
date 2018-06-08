module HighLevelTypes
export @hl #, @hldbg

const _hl_types = Dict{Symbol, Tuple}()

function maketypesconcrete(expression)
    for (i,arg) in enumerate(expression.args)
        if isa(arg, Symbol) 
            if haskey(_hl_types, arg)
                expression.args[i] = Symbol("", arg)
            end
        elseif :args in fieldnames(arg)
            maketypesconcrete(arg)
        end
    end
end

macro hl(typeexpr::Expr)
    @assert typeexpr.head == :type
    
    mutable, nameblock, args = typeexpr.args                
    maketypesconcrete(args)    
    
    if !isa(nameblock, Symbol) && nameblock.head == :<:        
        parentname = nameblock.args[2]
        nameblock = nameblock.args[1]        
    else
        parentname = :NOPARENT
    end

    if isa(nameblock, Symbol)
        name, params = nameblock, []
    elseif nameblock.head == :curly
        name, params = nameblock.args[1], nameblock.args[2:end]
    end
    
    if parentname == :NOPARENT         
        _hl_types[name] = params, args        
        acode = :(abstract type $name end)
    else
        _hl_types[name] = vcat(_hl_types[parentname][1], params), :( $(_hl_types[parentname][2].args...) ; $(args.args...))
        acode = :(abstract type $name <: $parentname end)
    end
            
    tname = Symbol(:_, name)
    tname = :($tname{})
    append!(tname.args, _hl_types[name][1]) 
    code = quote
        $acode
        type $tname <: $name
            $(_hl_types[name][2].args...)
        end
        $name(args...) = $(Symbol("_",name))(args...)
    end 
    esc(code)
end
 
end # module
