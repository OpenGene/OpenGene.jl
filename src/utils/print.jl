export @pcyan,@pblue,@pred,@pgreen


for (fn,clr) in ((:pcyan,   :cyan),
                 (:pblue,   :blue),
                 (:pred,    :red),
                 (:pgreen,  :green))

    @eval macro $fn(msg...)
        Base.print_with_color($(Expr(:quote, clr)), msg... )
    end
    
end
