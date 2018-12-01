//Hydrozoan Algorithm

clc

function y = fitness(hydrozoan)
    y = (hydrozoan(1)-1)^2 + 100*(hydrozoan(2) - hydrozoan(1)^2)^2;
endfunction

D = 2;
N = 3;
low = -2;
high = 1;
Iteration = 3; 
H = zeros(N,D);
ans = [];

for i=1:N
    for j=1:D
        H(i, j) = rand()*(high-low) + low; 
    end 
end

growth_low = 0.01;
growth_high = 0.1;

for itr=1:Iteration
    Fit = [];
    for i = 1:size(H,1)
        Fit = [Fit; fitness(H(i,:))];
    end
    
    G = []; N = size(H,1); D = size(H,2);
    for i=1:N
        G(i) = 1000/fitness(H(i,:));
    end
    
    Med = median(G); 
    
    Swarm = zeros(N);
    Swarm = G - Med;
    
    Split = zeros(N);
    
    Min = min(Swarm);
    Max = max(Swarm);
    for i = 1:N
        if(Swarm(i) < 0) then
            Split(i) = 0;
        elseif (Swarm(i) == 0) then
            Split(i) = 1;
        elseif (Swarm(i) > 0 & Swarm(i) == Min) then
            Split(i) = 1;
        elseif (Swarm(i) > 0 & Swarm(i) == Max) then
            Split(i) = 3;
        else
            Split(i) = 2;
        end    
    end
    
    //cloning
    Clone = [];
    
    for i = 1:N
        for j = 1:Split(i)
            Clone = [Clone; H(i,:)];
        end
    end
    
    
    //Mutation
    Min = 1e-2;
    Max = 1e-1;
     
    for i = 2:size(Clone,1)
        for j = 1:size(Clone,2)
            RP = (Max - Min)*rand() + Min;
            Clone(i,j) = Clone(i,j)*(1 + RP);      
        end
    end
    
    Fit = [];
    for i = 1:size(Clone, 1)
        Fit = [Fit; fitness(Clone(i,:))];
    end
    
    
    sum_of_fitness = 0;
    for i = 1:size(Clone ,1)
        sum_of_fitness = sum_of_fitness + Fit(i); 
    end
    
    Probability = [];
    
    for i = 1:size(Clone ,1)
        Probability = [Probability; (Fit(i)/sum_of_fitness)];
    end    
    
    par1 = -1;
    par2 = -1;
    first_max = 0;
    second_max = 0; 
    for i=1:size(Clone,1)
        if(first_max < Probability(i))
           second_max = first_max;
           par2 = par1;
           par1 = i;
           first_max = Probability(i); 
        elseif(second_max < Probability(i))
            second_max = Probability(i);
            par2 = i;
        end
    end
    
    swap_probability = 0.5;
    
    //Crossover
    for i=1:D
        if(swap_probability < rand())
            swap_val = Clone(par1,i);
            Clone(par1,i) = Clone(par2,i);
            Clone(par2,i) = swap_val;            
        end    
    end     
    
    min_fitness = min(Fit);
    for i=1:size(Clone, 1)
        if(fitness(Clone(i,:))<>min_fitness)
            Clone(i,1+floor(rand()*(D-1))) = low + rand()*(high-low);
        end
    end
    
    Fit = [];
    
    for i=1:size(Clone, 1)
        Fit = [Fit; fitness(Clone(i,:))];
    end
    
    Fit = gsort(Fit,'g','i');
    
    bestcount = 2;
    
    Fit_threshold = Fit(bestcount);
    
    for i=1:size(Clone, 1)
        if(fitness(Clone(i,:)) == Fit(1))
           Ibest = Clone(i,:);
           break;
        end
    end
    
    for i=1:size(Clone, 1)
        if(fitness(Clone(i,:)) >= Fit_threshold)
            Clone(i, :) = Ibest;
        end
    end
    
    ans = [ans; Fit(1)];
    disp('Iteration: ');
    disp(itr);
    disp('Fitness value:');
    disp(Fit(1));
    H = Clone;
end

//disp(Ibest);
final = mean(ans);
disp('Average fitness value:');
disp(final);
