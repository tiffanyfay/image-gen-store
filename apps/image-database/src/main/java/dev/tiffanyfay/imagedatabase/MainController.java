package dev.tiffanyfay.imagedatabase;

import org.springframework.web.bind.annotation.*;

@RestController // This means that this class is a RestController
@RequestMapping(path="/images") // This is where you can see and do REST calls for the DB
public class MainController {

    private final ImageRepository imageRepository;

    public MainController(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    @PostMapping
    public String addNewImage (@RequestBody ImageAPI imageAPI) {

        Image image = new Image(imageAPI.prompt(),imageAPI.url());
        imageRepository.save(image);
        return "Saved";
    }

    @GetMapping
    public Iterable<Image> getAllImages() {
        // This returns JSON with the images
        return imageRepository.findAll();
    }
}
