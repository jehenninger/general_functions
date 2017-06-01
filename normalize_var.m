function normalized = normalize_var(array, minValue, maxValue)

     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) ./ range;

     % Then scale to [x,y]:
     range2 = maxValue - minValue;
     normalized = (array*range2) + minValue;
end
