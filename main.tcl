namespace eval b {
    proc defun_header {} {
        puts "    push ebp"
        puts "    mov ebp, esp"
    }

    proc stack_allocate {var_count} {
        puts "    sub esp, [expr {$var_count * 8}]"
    }

    proc stack_cleanup {var_count} {
        puts "    add esp, [expr {$var_count * 8}]"
    }

    proc defun {name args body} {
        #codegen
        puts "$name:"
        defun_header
        stack_allocate [llength $args]
        stack_allocate [llength $args]
        puts "    ret"

        #metaprogramming

        set lines {}
        lappend lines "foreach arg \$args \{"
        lappend lines {    puts "    push $arg"} ;# body of foreach
        lappend lines "\}"                       ;# close foreach
        lappend lines "puts \"call $name:\""

        set code [list proc $name {args} [join $lines "\n"]]
        eval $code
    }
}

b::defun hello {times} {
        world
}
b::hello 5
