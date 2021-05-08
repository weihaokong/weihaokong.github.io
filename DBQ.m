function Y = DBQ(XX, num_training)
% XX: pre-quantization matrix m*n(m: number of items, n: number of dimensions), num_training: size of training set
% Y: binary matrix
% first num_training rows of XX are training data.
	m = size(XX,1);
	n = size(XX,2);
	Y = zeros(m,2*n);
	for i = 1 : n
		[leftThreshold,rightThreshold] = get0Fix3MeansThreshold(XX(1:num_training,i),num_training);
		index = XX(:,i)>rightThreshold;
		Y(index,i*2-1) = 1;
		index = XX(:,i)<leftThreshold;
		Y(index,i*2) = 1;
	end
end

function [leftThreshold,rightThreshold] = get0Fix3MeansThreshold(unSortedCol,num_training)
    workCol = sort(unSortedCol);
    sumLeft = workCol(1);
    sumRight = workCol(num_training);
    sumMid = sum(workCol)-sumLeft-sumRight;
    numMid = num_training-2;
    numLeft = 1;
    numRight = 1;
    res = 0;
    k = 0;
    while(1)
        k = k + 1;
        if (sumMid>0)
            sumMid=sumMid-workCol(num_training-numRight);
            numMid = numMid - 1;
            sumRight = sumRight + workCol(num_training-numRight);
            numRight = numRight + 1;
        else if (sumMid<0)
                sumMid = sumMid-workCol(numLeft+1);
                numMid = numMid - 1;
                sumLeft = sumLeft + workCol(numLeft+1);
                numLeft = numLeft + 1; 
            end
        end
        now = (sumRight*sumRight)/numRight + (sumMid*sumMid)/numMid + (sumLeft*sumLeft)/numLeft;
        if (now > res)
            res = now;
            leftThreshold = workCol(numLeft);
            rightThreshold = workCol(num_training-numRight);
            resLeft = numLeft;
            resRight = num_training - numRight;
        end   
        nowSample(k) = now;
        if (numMid==1) 
            break;
        end
    end
end