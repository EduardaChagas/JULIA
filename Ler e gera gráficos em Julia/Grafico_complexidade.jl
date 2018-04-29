using Gadfly
using Cairo

#Lendo o arquivo
x=Array{Float64}(10000000,2)
i=j=1
arquivo = open("entropia.txt","r")
while !eof(arquivo)
  linha=readline(arquivo)
if(linha!="\n")
  elemento=parse(Float64,linha)
  x[i,j]=elemento
  i+=1
  j+=1
  if(j<=2)
    i-=1
  end
  if(j>2)
    j=1
  end
end
end
close(arquivo)

#Armazenando os valores
elementos_x=Array{Float64}(i-1)
elementos_y=Array{Float64}(i-1)
for k in 1:(i-1)
 elementos_x[k]=x[k,1]
 elementos_y[k]=x[k,2]
end

#Gerando o gráfico
draw(PDF("grafico2.pdf", 15cm, 15cm), plot(x=elementos_x,y=elementos_y,Guide.xlabel("Permutation Entropy"),Guide.ylabel(" MPR - Statistical Complexity"),Guide.title("Gráfico da Série Temporal"),Geom.line))


		
