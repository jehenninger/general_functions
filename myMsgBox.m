function [h] = myMsgBox(message)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h = msgbox(message,'Visible','off');
hc = get(h,'Children');
set(hc(1),'Visible','off');

h.Visible = 'on';

end

