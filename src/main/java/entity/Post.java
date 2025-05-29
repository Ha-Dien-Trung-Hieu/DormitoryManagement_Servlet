package entity;


@Entity
@Table(name = "post")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Integer postId;

    @Column(name = "student_id")
    private String studentId;

    @Column(name = "content")
    private String content;

    @Column(name = "image")
    private byte[] image;

    @Column(name = "created_at")
    private Timestamp createdAt;

    // Getters và Setters
    public Integer getPostId() { return postId; }
    public void setPostId(Integer postId) { this.postId = postId; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}