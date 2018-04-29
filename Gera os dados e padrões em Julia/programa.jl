#Reading the variables
print("D : ")
valor1=readline(STDIN)
D=parse(Int64,valor1)
print("J : ")
valor1=readline(STDIN)
J=parse(Int64,valor1)

#Initializing values
m1=Array{Float64}(100000,D)
m2=Array{Int64}(D)
x=Array{Float64}(1000000)
i=w=j=1
cont=0
sair=0

#Reading the file
arquivo = open("date.txt","r")
while !eof(arquivo)
  linha=readline(arquivo)
  elemento=parse(Float64,linha)
  x[i]=elemento
  i+=1
end
close(arquivo)

#Defining sets
i=conjunto=1
while i<=100000
  for j=1:D
    m1[conjunto,j]=x[i+(j-1)]
    if i+(j-1)==100000
      sair+=1
      break
    end
  end
  if sair!=0 && j!=D
    conjunto-=1
    break
  end
  if sair!=0 && j==D
    break
  end
  conjunto+=1
  i+=J
end

#Initializing the array 
for i=1:D
  m2[i]=i
end

#Initializing array 2
matriz=collect(permutations(m2))

#Initializing values 
fat=factorial(D)
a=zeros(Int64,fat)

#Exchanging and defining symbols
#Analyzing each set
i=j=1
w=soma=0
for i=1:conjunto
  #Analyzing each element in the set
  for j=1:D
    if j!=D
      w=j+1    
      while w<=D
        if m1[i,j]>m1[i,w]
          a1=m1[i,j]
          m1[i,j]=m1[i,w]
          m1[i,w]=a1
          a2=m2[j]
          m2[j]=m2[w]
          m2[w]=a2
        end
        w+=1
      end
    end
  end
  for j=1:fat
    if matriz[j]==m2
      a[j]=a[j]+1
      soma+=1
      break
    end
  end
  for i=1:D
    m2[i]=i
  end
end

#Displaying on the screen
for i=1:fat
b=a[i]
  println("Simbolo $i:  ",matriz[i]," Quantidade: $b")
end

