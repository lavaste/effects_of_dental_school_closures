#Legend
ggplot(schools2) +
  geom_segment(aes(1990, label2, xend=closed, yend=label2, color="New students admitted"), linewidth=14) +
  geom_segment(aes(closed, label2, xend=reopened, yend=label2, color="No admissions"), linewidth=14) +
  geom_segment(aes(reopened, label2, xend=2020, yend=label2, color="New students admitted"), linewidth=14) +
  geom_segment(aes(1990, label2, xend=grad_last, yend=label2, color="New graduates"), linewidth=3, linetype="solid") +
  geom_segment(aes(grad_new, label2, xend=2020, yend=label2, color="New graduates"), linewidth=3, linetype="solid") +
  labs(x=NULL, y=NULL, title="Dental schools:") +
  theme_minimal() +
  scale_x_continuous(n.breaks=16) +
  scale_y_discrete(limits=rev) +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1, size=15),axis.text.y = element_text(size=18), axis.text=element_text(color="black")) +
  theme(legend.position="bottom", legend.spacing.y = unit(.1, 'cm'), legend.margin=margin(t = 0, unit='cm')) +
  theme(legend.text=element_text(size=13, margin = margin(t=10, b=10)), legend.key.size = unit(.5, "cm"), legend.key.height = unit(.5, "cm")) +
  guides(colour = guide_legend(reverse=TRUE, nrow=2, byrow = TRUE)) +
  theme(plot.title=element_text(hjust=-.4, size=20, face="bold")) + #0.5 = centering
  theme(legend.direction="horizontal") +
  theme(plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  scale_color_manual(values=c("#474f58","#8fd175","#d18975"),name=NULL)
ggsave("legend.pdf", width = 15, height = 12, units = "cm", device="pdf", dpi=600)
