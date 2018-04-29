#Function in Julia

using Gadfly
using Cairo

function menu_opcoes(serie,dimensao,delay,opcao=0,number_of_pattern=0,pontos=0,quantidade=0)

		#Variables
		quantidade = length(dimensao)
		n_simbolos = 1
		fat = factorial(dimensao)
		vetor = Array(1:dimensao)
		simbolos = Array{Int64}(fat,dimensao)
		comb = collect(permutations(vetor))
		p = Array{Int64}(dimensao)
		aux = Arra{Float64}(dimensao)
  		p_padroes = indice = Array{Int64}(quantidade,dimensao)
  		elementos = Array{Float64}(quantidade,dimensao)
  		contagem_dos_padroes = zeros(fat)


		for i = 1:endof(comb)
			for j = 1:dimensao
				simbolos[i,j] = comb[i][j]
			end
		end

		i = inicial = 1
		ind_rep = zeros(n_simbolos)


		while i<=quantidade
			for j=1:dimensao
				elementos[n_simbolos,j] = serie[i]
				indice[n_simbolos,j] = i
				i += 1
				if i>quantidade
					break
				end
			end

			if j == dimensao
				#Realizando a formacao do padrao
				for i=1:dimensao
					aux[i] = elementos[n_simbolos,i]
				end
				p = sortperm(aux)
				for i=1:dimensao
					for j=1:dimensao
						if elementos[n_simbolos,p[i]] == elementos[n_simbolos,j]
							p_padroes[n_simbolos,j] = i
						end
					end
				end
				for j=1:fat
					if p_padroes[n_simbolos,:] == simbolos[j,:]
						indice_rep[n_simbolos] = j
						contagem_dos_padroes[j] += 1
						break
					end
				end
				i = inicial + delay
				inicial = i
				n_simbolos += 1
			end
		end

      	n_simbolos -= 1
  		if opcao == 0 
  			#Calculando a frequencia relativa
  			patterns = indice_rep[1:n_simbolos]
  			plot(x = patterns, Guide.xlabel = "Patterns", Guide.ylabel = "Density", Guide.title = "Histogram of the patterns", color = "red", Geom.histogram(density = true))
  			println(simbolos)
  		else 
	  		if opcao == 1
	  			comprimento = 0
	  			point_time = Array{Int64}(quantidade)
	  			point_value = Array{Float64}(quantidade)
	  			for i=1:n_simbolos
	  				if p_padroes[i,] == simbolos[number_of_pattern,] 
	  					if pontos == 0
	  						comprimento += 1
	  						point_value[comprimento] = elementos[i,1]
	  						point_time[comprimento] = indice[i,1]
	  					else
	  						for j=1:dimensao
	  							comprimento += 1
	  							point_value[comprimento] = elementos[i,j]
	  							point_time[comprimento] = indice[i,j]
	  						end
	  					end
	  				end
	  			end
	  			vetor = Array(1:length(serie))
	  			if comprimento != 0
		  			draw(PDF("grafico.pdf", 15cm, 15cm), plot(layer(x=vetor,y=serie, color = "red", Geom.line),
		  			layer(x = point_time[1:comprimento], y = point_value[1:comprimento], color = "blue", Geom.point)
		  			,Guide.xlabel("Time"),Guide.ylabel("Serie"),Guide.title("Graphics of time serie")))
		  		else
		  			draw(PDF("grafico.pdf", 15cm, 15cm), plot(x=vetor,y=serie, color = "red", Geom.line,Guide.xlabel("Time"),Guide.ylabel("Serie"),Guide.title("Graphics of time serie")))
		  		end
		  	else
		  		if opcao == 2		  		 	
  					return(distribuicao(dimensao,p_padroes,simbolos,n_simbolos))
  				else
  					if opcao == 3
					    probabilidade = distribuicao(dimensao,p_padroes,simbolos,n_simbolos)
					    return(entropia_shannon(probabilidade,dimensao,1))
					else
						if opcao == 4
						    probabilidade = distribuicao(dimensao,p_padroes,simbolos,n_simbolos)
						    return(entropia_shannon(probabilidade,dimensao,0))
						end
					end
				end
			end
		end
end


function distribuicao(dimensao,p_padroes,simbolos,n_simbolos)
	fat = factorial(dimensao)
	f_absoluta = probabilidade = zeros(fat)
	aux = zeros(n_simbolos)
	for i = 1:fat
		for j = 1:n_simbolos
			if aux[j] == 0
				if	p_padroes[j,] == simbolos[i,]
					f_absoluta[i] = f_absoluta[i] + 1
					aux[j] = 1
				end
			end
		end
		probabilidade[i] = (f_absoluta[i] / n_simbolos)
	end
end

function entropia_shannon(proababilidade,dimensao,opcao)
	entropia = 0
	fat = factorial(dimensao)
	for i = 1:fat
		if probabilidade[i] != 0
			entropia = entropia + (probabilidade[i] * log(probabilidade[i]))
		end
	end
	entropia = entropia * (-1)
	if opcao == 1
		return entropia
	else
		entropia= entropia / log(fat)
		return entropia
	end
end

function time_series(serie)
	vetor = Array(1:length(serie))
	plot(x = vetor, y = serie, Guide.xlabel("Time"), Guide.ylabel("Serie"), Guide.title("Graphics of time serie"), color = "red", Geom.line)
end

function distancias(serie,dimensao,delay,opcao)
	probabilidade = menu_opcoes(serie,dimensao,delay,opcao=2)
	distancia = 0
	if(opcao == 1)
		distancia  distancia_euclidiana(dimensao,probabilidade)
	end
	if(opcao == 2)
		distancia = distancia_euclidiana_quadratica(dimensao,probabilidade)
	end
	if(opcao == 3)
		distancia = distancia_manhattan(dimensao,probabilidade)
	end
	if(opcao == 4)
		distancia = distancia_chebyshev(dimensao,probabilidade)
	end
	if(opcao == 5)
		distancia = divergencia_kullback_leibler(dimensao,probabilidade)
	end
	if(opcao == 6)
		distancia = distancia_hellinger(dimensao,probabilidade)
	end
	if(opcao == 7)
		distancia = divergencia_shannon(dimensao,probabilidade)
	end
	return distancia
end


function distancia_euclidiana(dimensao,probabilidade)
	fat = factorial(dimensao)
	distance = 0
	for i=1:fat
		distance += ((probabilidade[i] - (1/fat))^2)
	end
	return sqrt(distance)
end

function distancia_quadratica(dimensao,probabilidade)
	distance = 0
	fat = factorial(dimensao)
	for i=1:fat
		distance += ((probabilidade[i] - (1/fat)) ^2)
	end
	return distance
end


function distancia_manhattan(dimensao,probabilidade)
	distance = 0
	fat = factorial(dimensao)
	for i=1:fat
		distance += abs(probabilidade[i] - (1/fat))
	end
	retrun distance
end


function distancia_chebyshev(dimensao,probabilidade)
	fat = factorial(dimensao)
	L = zeros(fat)
	for i=1:fat
		L[i] = abs(probabilidade[i] - (1/fat))
	end
	return maximum(L)
end


function divergencia_kullback_leibler(dimensao,probabilidade)
	distance = 0
	fat = factorial(dimensao)
	for i = 1:fat
		distance += (probabilidade[i] * log(probabilidade[i]/(1/fat)))
	end
	return distance
end

function distancia_hellinger(dimensao,probabilidade)
	distance = 0
	fat = factorial(dimensao)
	for i = 1:fat
		distance += (sqrt(probabilidade[i] - sqrt((1/fat) ^ 2)))
	end
	distance *= 0.5
	return sqrt(distance)
end

function divergencia_shannon(dimensao,probabilidade)
	fat = factorial(dimensao)
	p = (probabilidade + (1/fat)) * 0.5
	A = entropia_shannon(P,dimensao,1)
	K = entropia_shannon(probabilidade,dimensao,1)
	R = entropia_shannon(c,dimensao,1)
	B = ((K + R) * 0.5) * (-1)
	return (A + B) 
end

function distancia_wootters(probabilidade,q)
	distancia = 0
	n = length(probabilidade)
	for i = 1:n
		distancia += (sqrt(probabilidade[i] * (1/n)))
	end
	distancia = acos(distancia)
	return distancia
end

function entropia_tsallis(probabilidade,q,opcao)
	entropia = 0
	n = length(probabilidade)
	for i = 1:n
		entropia += (probabilidade[i] ^ q)
	end
	entropia = (1 - entropia) * (1/(q - 1))
	if(opcao == 0)
		return entropia
	end
	if(opcao == 1)
		entropia_max = (1 - (n ^(1 - q)))/(q - 1)
		entropia /= entropia_max
		return entropia
	end
end

function entropia_Renyi(probabilidade,q,opcao)
	entropia = 0
	for i = 1:llength(probabilidade)
		entropia += (probabilidade[i] ^ q)
	end
	entropia = log(entropia)
	entropia *= (1/(1 - q))
	if(opcao == 0)
		return entropia
	end
	if(opcao == 1)
		entropia /= log(length(probabilidade))
		return entropia
	end
end
