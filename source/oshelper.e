include std/filesys.e 
include std/error.e 
include std/io.e 
include std/pipeio.e as pipe 

public function execCommand(sequence cmd) 
    sequence s = "" 
    object z = pipe:create() 
    object p = pipe:exec(cmd, z) 
    if atom(p) then 
        printf(2, "Failed to exec() with error %x\n", pipe:error_no()) 
        pipe:kill(p) 
        return -1 
    end if 
    object c = pipe:read(p[pipe:STDOUT], 256) 
    while sequence(c) and length(c) do 
        s &= c 
        if atom(c) then 
            printf(2, "Failed on read with error %x\n", pipe:error_no()) 
            pipe:kill(p) 
            return -1 
        end if 
        c = pipe:read(p[pipe:STDOUT], 256) 
    end while 
    --Close pipes and make sure process is terminated 
    pipe:kill(p) 
    return s 
end function 