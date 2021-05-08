function  Y = MH(XX,q,num_training)
% XX: pre-quantization matrix m*n(m: number of items, n: number of dimensions), 
% q: bits per dimension, 
% num_training: size of training set.
% Y: binary matrix.
	n = size(XX,2);
	k = 2^q;
	Y = zeros(size(XX,1),n);
	XTraining = XX(1:num_training,:);% first num_training rows of them are training data.
	for i = 1 : n
		sample = randperm(num_training);
		sample = sample(1:k);
		sample = XX(sample,i);
		sample = sort(sample);
		%sample
		[singleY,location] = kmeans(XTraining(:,i),k,'start',sample,'MaxIter',20,'emptyaction','singleton');
		for index = num_training+1:size(XX,1)
			[~,singleY(index)] = min(abs(location-XX(index,i)));
		end
		Y(:,i) = singleY;
	end
end
