package com.example.backend.controller;

import com.example.backend.model.Message;
import com.example.backend.model.User;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ApiController {

    private final List<User> users = new ArrayList<>();

    public ApiController() {
        // Initialize with sample data
        users.add(new User(1L, "John Doe", "john@example.com"));
        users.add(new User(2L, "Jane Smith", "jane@example.com"));
        users.add(new User(3L, "Bob Johnson", "bob@example.com"));
    }

    @GetMapping("/health")
    public Message health() {
        return new Message("Backend is running!", LocalDateTime.now().toString());
    }

    @GetMapping("/users")
    public List<User> getUsers() {
        return users;
    }

    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return users.stream()
                .filter(u -> u.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        user.setId((long) (users.size() + 1));
        users.add(user);
        return user;
    }

    @GetMapping("/info")
    public Message getInfo() {
        return new Message(
                "Docker Assignment Backend API",
                "Version 1.0.0 - Running on Java 17 with Spring Boot 3.2.0"
        );
    }
}

