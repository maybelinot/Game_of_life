% zmena stavu tlacitku
    function status_of_button(status,generatematrix,worldsize,closebutton,speedslider,clearworldbutton,graphics,numofgeneration,draw_button)
        % function status_of_button(status)
        % status: 'on' nebo 'off' zapnout /vypnout tlacitko
        set(generatematrix,'enable', status);
        set(worldsize,'enable', status);
        set(closebutton,'enable', status);
        set(speedslider,'enable', status);
        set(clearworldbutton,'enable', status);
        set(graphics,'enable', status);
        set(numofgeneration,'enable', status);
        set(draw_button,'enable', status);
    end
