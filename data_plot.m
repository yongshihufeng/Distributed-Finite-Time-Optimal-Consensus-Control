clear; clc; close all;
load('data.mat');
linew = 0.5;
figure(1); clf;
subplot(2,1,1); hold on;
plot(t, yd, 'k--', 'LineWidth',1.5);
for j=1:num_motors, plot(t, x1(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('Position'); legend([{'yd'}, motor_labels]); box on;
subplot(2,1,2); hold on;
for j=1:num_motors, plot(t, x2(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('Velocity'); legend(motor_labels); box on;
figure(2); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, sync_pos(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('x_i - x_{avg}'); legend(motor_labels); box on;
subplot(2,1,2); plot(t, norm_sync_pos, 'k', 'LineWidth',1.5);
xlabel('Time (s)'); ylabel('||sync_pos||_2'); box on;
figure(3); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, sync_vel(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('v_i - v_{avg}'); legend(motor_labels); box on;
subplot(2,1,2); plot(t, norm_sync_vel, 'k', 'LineWidth',1.5);
xlabel('Time (s)'); ylabel('||sync_vel||_2'); box on;
figure(4); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, alpha1(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('\alpha_1'); legend(motor_labels); box on;
subplot(2,1,2); hold on;
for j=1:num_motors, plot(t, u(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('u'); legend(motor_labels); box on;
figure(5); clf;
subplot(3,1,1); hold on;
for j=1:num_motors, plot(t, cost_inst(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('L(t)'); legend(motor_labels); box on;
subplot(3,1,2); hold on;
for j=1:num_motors, plot(t, cost_int(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('J(t)'); legend(motor_labels); box on;
subplot(3,1,3); hold on;
for j=1:num_motors, plot(t, energy(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('Energy'); legend(motor_labels); box on;
figure(6); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, Wc_norm(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('||W_c||'); legend(motor_labels); box on;
subplot(2,1,2); hold on;
for j=1:num_motors, plot(t, Wa_norm(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('||W_a||'); legend(motor_labels); box on;
figure(7); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, u_error(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('|e_u|'); legend(motor_labels); box on;
subplot(2,1,2); hold on;
for j=1:num_motors, plot(t, threshold(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('Threshold'); legend(motor_labels); box on;
figure(8); clf;
subplot(2,1,1); hold on;
for j=1:num_motors, plot(t, cum_trig(:,j), colors{j}, 'LineWidth',linew); end
xlabel('Time (s)'); ylabel('Cumulative triggers'); legend(motor_labels); box on;
subplot(2,1,2); hold on;
for j=1:num_motors
    if ~isempty(inter_trigger{j})
        stem(trigger_times{j}(2:end), inter_trigger{j}, 'filled', colors{j});
    end
end
xlabel('Time (s)'); ylabel('Inter-event time'); legend(motor_labels); box on;
for figNum = 1:8
    figure(figNum);
    if figNum == 5
        set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 10, 8.5]);
    else
        set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 10, 6]);
    end
    allAxes = findobj(gcf, 'Type', 'axes');
    for ax = allAxes'
        set(ax, 'FontSize', 6, 'Box', 'on');
        ax.XLabel.FontSize = 6;
        ax.YLabel.FontSize = 6;
        hLeg = get(ax, 'Legend');
        if ~isempty(hLeg), set(hLeg, 'FontSize', 6); end
        lines = findobj(ax, 'Type', 'line');
        if ~isempty(lines)
            yMin = inf; yMax = -inf;
            for k = 1:length(lines)
                yData = lines(k).YData;
                if ~isempty(yData)
                    yMin = min(yMin, min(yData));
                    yMax = max(yMax, max(yData));
                end
            end
            if isfinite(yMin) && isfinite(yMax)
                range = yMax - yMin;
                if range == 0, yMin = yMin - 0.1; yMax = yMax + 0.1;
                else, yMin = yMin - 0.02*range; yMax = yMax + 0.02*range; end
                ylim(ax, [yMin, yMax]);
            end
        end
    end
    set(gcf, 'Renderer', 'painters');
end
for figNum = 1:8
    figure(figNum);
    set(gcf, 'PaperPositionMode', 'auto');
    print(gcf, sprintf('Fig%d.eps', figNum), '-depsc', '-r600', '-loose');
    fprintf('Figure %d saved as Fig%d.eps\n', figNum, figNum);
end