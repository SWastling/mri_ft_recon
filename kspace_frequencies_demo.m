% Demonstration of spatial frequencies in MRI k-space

% Written by Stephen Wastling, October 2022

% set the matrix size
Nx = 32;
Ny = 32;

% set the FOV, noting it will be centred about the origin
FOVx = 20;
FOVy = 20;

% generate the image space axes
x = -FOVx / 2 : FOVx / Nx : FOVx / 2;
y = -FOVy / 2 : FOVy / Ny : FOVy / 2;

% generate the k-space axes
kx = -Nx / (2 * FOVx) : (1 / FOVx) : Nx / (2 * FOVx);
ky = -Ny / (2 * FOVy) : (1 / FOVy) : Ny / (2 * FOVy);

% initialise the data array
phi = zeros(length(x), length(y));
for b = 1 : 4 :length(ky)
    for a = 1 : 4 : length(kx)

        for i = 1 : length(x)
            for j = 1 : length(y)
                phi(j, i) = cos(kx(a) * x(i) + ky(b) * y(j));
            end
        end

        figure(1);
        subplot(1, 2, 1);
        imagesc(x, y, phi)
        title('cos(k.r)')
        xlabel('x (cm)')
        ylabel('y (cm)')
        colormap('gray')
        axis square

        subplot(1,2,2);
        plot(kx(a), ky(b), 'ro')
        title('k-space')
        xlabel('k_x (cm^{-1})')
        ylabel('k_y (cm^{-1})')
        xlim([min(kx) max(kx)])
        ylim([min(ky) max(ky)])
        axis square
        
        
         % generate gif
        set(gcf, 'color', 'w');
        drawnow;
        frame = getframe(1);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        outfile = 'kspace_frequencies.gif';

        % On the first loop, create the file. In subsequent loops, append.
        if a == 1 && b == 1
            imwrite(imind, cm, outfile, 'gif','DelayTime', 0, 'loopcount', inf);
        else
            imwrite(imind, cm, outfile,'gif', 'DelayTime', 0, 'writemode', 'append');
        end

    end
end

