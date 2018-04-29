#Reading the variables
print("D : ")
valor1=readline(STDIN)
D=parse(Int64,valor1)
print("J : ")
valor1=readline(STDIN)
J=parse(Int64,valor1)

#Initializing values
m1=Array{Float64}(100000,D)
m2=Array{Int64}(100000,D)
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

#Initializing values 2
fat=factorial(D)
array=Array{Int64}(fat,D+1)
grupo=igual=w=a1=a2=a=b=0

#Initializing the array
for f=1:100000
  for j=1:D
    m2[f,j]=j-1
  end
end

#Initializing the array 2
for i=1:fat
  array[i,D+1]=0
end

#Exchanging and defining symbols
#Analyzing each set
i=j=1
w=0
for i=1:conjunto
  #Analyzing each element in the set
  for j=1:D
    w=j+1
    while w<=D
      if m1[i,j]>m1[i,w]
        a1=m1[i,j]
        m1[i,j]=m1[i,w]
        m1[i,w]=a1
        a2=m2[i,j]
        m2[i,j]=m2[i,w]
        m2[i,w]=a2
      end
      w+=1
    end
  end

  #Increasing groups
  j=w=1
  if grupo!=0
    for j=1:grupo
      for w=1:D
        if m2[i,w]==array[j,w]
          igual+=1
        end
      end
      if igual==D
        array[j,D+1]+=1
        break
      else
        igual=0
      end
    end
    if igual!=D
      sair+=1
    end
    igual=0
  end

  #Forming new groups
  j=1
  if grupo==0||sair!=0
    grupo+=1
    for j=1:D
      array[grupo,j]=m2[i,j]
    end
    array[grupo,D+1]+=1
    sair=0
  end
end

  #Displaying on the screen
  a=b=0
  i=j=1
  for i=1:grupo
    print("Simbolo $i: ")
    for j=1:D
      a=array[i,j]
      print(a," ")
    end
    b=array[i,D+1]
    print("Quantidade: $b\n")
  end


