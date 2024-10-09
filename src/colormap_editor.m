function colormap_editor
    screenSize = get(0, 'ScreenSize');
    figWidth = 900;
    figHeight = 600;
    figPosX = (screenSize(3) - figWidth) / 2;
    figPosY = (screenSize(4) - figHeight) / 2;

    hFig = figure('Name', 'Colormap Editor', 'NumberTitle', 'off', ...
        'MenuBar', 'none', 'Toolbar', 'none', 'Position', [figPosX, figPosY, figWidth, figHeight]);

    cmap = [];
    cmap_size = 64;
    selected_row = [];

    uicontrol('Style', 'popupmenu', 'String', {'2','4','8','16','32','64','128','256'}, ...
        'Position', [20, 550, 100, 30], 'Value', 6, 'Callback', @set_cmap_size);

    uicontrol('Style', 'pushbutton', 'String', 'Add Color', ...
        'Position', [140, 550, 100, 30], 'Callback', @add_color);

    uicontrol('Style', 'pushbutton', 'String', 'Delete Color', ...
        'Position', [260, 550, 100, 30], 'Callback', @delete_color);

    uicontrol('Style', 'pushbutton', 'String', 'Random Colormap', ...
        'Position', [380, 550, 120, 30], 'Callback', @random_colormap);

    uicontrol('Style', 'pushbutton', 'String', 'Import Colormap', ...
        'Position', [520, 550, 120, 30], 'Callback', @import_colormap);

    uicontrol('Style', 'pushbutton', 'String', 'Export Colormap', ...
        'Position', [660, 550, 120, 30], 'Callback', @export_colormap);

    uicontrol('Style', 'pushbutton', 'String', 'Import from Workspace', ...
        'Position', [20, 510, 180, 30], 'Callback', @import_from_workspace);

    uicontrol('Style', 'pushbutton', 'String', 'Export to Workspace', ...
        'Position', [220, 510, 180, 30], 'Callback', @export_to_workspace);

    t = uitable('Position', [20, 50, 300, 450], 'CellSelectionCallback', @table_select);

    ax = axes('Units', 'pixels', 'Position', [350, 50, 520, 450]);
    set(ax, 'ButtonDownFcn', @palette_click);

    cmap = zeros(cmap_size, 3);
    update_display();

    function set_cmap_size(src, ~)
        sizes = [2, 4, 8, 16, 32, 64, 128, 256];
        cmap_size = sizes(get(src, 'Value'));
        cmap = zeros(cmap_size, 3);
        update_display();
    end

    function import_colormap(~, ~)
        [file, path] = uigetfile('*.mat', 'Select a colormap file');
        if isequal(file, 0)
            return;
        end
        data = load(fullfile(path, file));
        if isfield(data, 'cmap')
            cmap = data.cmap;
            cmap_size = size(cmap, 1);
            update_display();
        else
            errordlg('The file does not contain a valid colormap named ''cmap''.', 'Error');
        end
    end

    function export_colormap(~, ~)
        [file, path] = uiputfile('*.mat', 'Save colormap as');
        if isequal(file, 0)
            return;
        end
        cmap_to_save = cmap;
        save(fullfile(path, file), 'cmap');
        msgbox('Colormap saved successfully.', 'Success');
    end

    function import_from_workspace(~, ~)
        prompt = {'Enter the colormap name in the workspace:'};
        dlgtitle = 'Import from Workspace';
        dims = [1 50];
        definput = {'cmap'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        if ~isempty(answer)
            var_name = answer{1};
            if evalin('base', sprintf('exist(''%s'', ''var'')', var_name))
                temp_cmap = evalin('base', var_name);
                if isnumeric(temp_cmap) && size(temp_cmap, 2) == 3
                    cmap = temp_cmap;
                    cmap_size = size(cmap, 1);
                    update_display();
                else
                    errordlg('The selected variable is not a valid colormap.', 'Error');
                end
            else
                errordlg('The variable does not exist in the workspace.', 'Error');
            end
        end
    end

    function export_to_workspace(~, ~)
        prompt = {'Enter the variable name:'};
        dlgtitle = 'Export to Workspace';
        dims = [1 50];
        definput = {'cmap'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        if ~isempty(answer)
            assignin('base', answer{1}, cmap);
            msgbox('Colormap exported to workspace.', 'Success');
        end
    end

    function add_color(~, ~)
        new_color = uisetcolor([1 1 1], 'Select a new color');
        if length(new_color) == 3
            cmap = [cmap; new_color];
            cmap_size = size(cmap, 1);
            adjust_colormap();
            update_display();
        end
    end

    function delete_color(~, ~)
        if ~isempty(selected_row)
            cmap(selected_row, :) = [];
            selected_row = [];
        else
            cmap(end, :) = [];
        end
        cmap_size = size(cmap, 1);
        if cmap_size < 1
            cmap = zeros(1, 3);
            cmap_size = 1;
        end
        adjust_colormap();
        update_display();
    end

    function random_colormap(~, ~)
        cmap = rand(cmap_size, 3);
        adjust_colormap();
        update_display();
    end

    function table_select(~, event)
        if isempty(event.Indices)
            return;
        end
        selected_row = event.Indices(1);
        t.Data = t.Data;  % Refresh the table to trigger the selection
        edit_color(selected_row);
    end

    function palette_click(~, ~)
        cp = get(ax, 'CurrentPoint');
        x = cp(1,1);
        col_index = round(x);
        if col_index >= 1 && col_index <= cmap_size
            selected_row = col_index;
            edit_color(selected_row);
        end
    end

    function edit_color(row)
        current_color = cmap(row, :);
        new_color = uisetcolor(current_color, 'Select a new color');
        if length(new_color) == 3
            cmap(row, :) = new_color;
            adjust_colormap();
            update_display();
        end
    end

    function adjust_colormap()
        x = linspace(0, 1, size(cmap, 1));
        xi = linspace(0, 1, cmap_size);
        cmap = [interp1(x, cmap(:,1), xi)', interp1(x, cmap(:,2), xi)', interp1(x, cmap(:,3), xi)'];
    end

    function update_display()
        num_colors = size(cmap, 1);
        cmap_indices = (1:num_colors)';
        t.Data = [cmap_indices, cmap];
        t.ColumnName = {'Index', 'R', 'G', 'B'};
        t.ColumnEditable = false(1, 4);
        t.ColumnWidth = {50, 50, 50, 50};

        imagesc((1:num_colors)', 'Parent', ax);
        colormap(ax, cmap);
        ax.YTick = [];
        ax.XTick = [];
    end
end
