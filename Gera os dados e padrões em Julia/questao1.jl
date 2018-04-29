arquivo=open("date.txt","a")
x0=x1=0.1
for i = 1:100000
  x1 = 4 * x0 * (1 - x0)
  x0 = x1
end
print("Digite a quantidade de dados: ")
elemento=readline(STDIN)
n=parse(Int64,elemento)
println(arquivo,n)
print("Digite o comprimento dos padroes: ")
elemento=readline(STDIN)
m=parse(Int64,elemento)
println(arquivo,m)
print("Digite o delay dos padroes: ")
elemento=readline(STDIN)
m=parse(Int64,elemento)
println(arquivo,m)
for i = 1:n
  x1 = 4 * x0 *(1 -x0)
  println(arquivo,x1)
  x0=x1
end
close(arquivo)
