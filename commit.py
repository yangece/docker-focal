import subprocess

op = subprocess.check_output(["docker", "ps","-a"]).decode('utf-8')
op = op.split("\n")
for i in op:
    i = i.split()
    try:
        if(i[1] == "thrive20/ubuntu-focal:latest"):
            print([i[0], i[1]])
            op = subprocess.check_output(["docker","commit",i[0], i[1]])
            print(op)
    except:
        pass
