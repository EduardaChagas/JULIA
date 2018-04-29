using Gadfly
using Cairo

arquivo=open("date.txt","r")

#Dados
linha=readline(arquivo)
elemento=parse(Int64,linha)
i=1
vetor=Array{Float64}(elemento)
indice=Array{Float64}(elemento)

#Armazenando os dados do arquivo
while !eof(arquivo)
	linha=readline(arquivo)
	elemento=parse(Float64,linha)
	vetor[i]=elemento
	indice[i]=i
	i=i+1	
end
close(arquivo)
	
#Gerando o grafico
draw(PDF("grafico.pdf", 15cm, 15cm), plot(x=vetor,y=indice,Guide.xlabel("Serie Temporal"),Guide.title("Grafico da Serie Temporal"),Geom.line))
