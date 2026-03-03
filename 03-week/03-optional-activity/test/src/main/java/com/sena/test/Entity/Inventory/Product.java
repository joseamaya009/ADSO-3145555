package com.sena.test.Entity.Inventory;

    import jakarta.persistence.Column;
    import jakarta.persistence.Entity;
    import jakarta.persistence.GeneratedValue;
    import jakarta.persistence.GenerationType;
    import jakarta.persistence.Id;
    import jakarta.persistence.ManyToOne;
    import jakarta.persistence.JoinColumn;

    import lombok.AllArgsConstructor;
    import lombok.Getter;
    import lombok.Setter;
    import lombok.NoArgsConstructor;
    import lombok.ToString;

    @Entity
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @ToString(exclude = "category")

public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 60)
    private String name;

    @Column(nullable = false)
    private Double price;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

}
