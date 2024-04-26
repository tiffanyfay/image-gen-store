package dev.tiffanyfay.imagedatabase;

import jakarta.persistence.*;

@Entity //Create a table out of this class
public class Image {
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Integer id;
    @Column(columnDefinition = "TEXT") // Needed for longer text than var255
    private String prompt;
    @Column(columnDefinition = "TEXT")
    private String url;

    protected Image() {}

    public Image(String prompt, String url) {
        this.prompt = prompt;
        this.url = url;
    }

    public Integer getId() {
        return id;
    }

    public String getPrompt() {
        return prompt;
    }

    public String getUrl() {
        return url;
    }
}
