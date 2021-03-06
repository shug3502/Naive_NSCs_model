function abc_plotter(theta,dist,real_theta,R)
to_keep = (dist <= quantile(dist,0.005));
qt = theta(:,to_keep);
figure;
for i=1:2
subplot(2,1,i); hist(qt(i,:));
hold on;
plot(real_theta(i),0,'xg');
end

empirical_pdf_plot(qt(1,:),qt(2,:),linspace(0,R,101),linspace(0,R,101));
hold on 
plot(real_theta(1),real_theta(2),'mx','markerSize',10)


