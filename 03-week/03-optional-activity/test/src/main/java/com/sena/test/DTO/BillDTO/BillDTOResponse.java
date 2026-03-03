package com.sena.test.DTO.BillDTO;

    import java.time.LocalDate;
    import java.util.List;
    
    import lombok.Getter;
    import lombok.Setter;

    @Getter
    @Setter

public class BillDTOResponse {
    private Long id;
    private LocalDate  date ;
    private String username ;
    private Double total;  
    private List<BillDetailDTOResponse> details ;
}
