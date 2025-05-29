package entity;

@Entity
@Table(name = "post_like")
@IdClass(PostLikeId.class)
public class PostLike {
    @Id
    @Column(name = "post_id")
    private Integer postId;

    @Id
    @Column(name = "student_id")
    private String studentId;

    @Column(name = "created_at")
    private Timestamp createdAt;

    // Getters và Setters
    public Integer getPostId() { return postId; }
    public void setPostId(Integer postId) { this.postId = postId; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

class PostLikeId implements Serializable {
    private Integer postId;
    private String studentId;
}