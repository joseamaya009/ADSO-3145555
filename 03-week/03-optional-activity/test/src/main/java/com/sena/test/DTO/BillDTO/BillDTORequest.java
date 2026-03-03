package com.sena.test.DTO.BillDTO;

    import java.time.LocalDate;
    import java.util.List;
    
    import lombok.Getter;
    import lombok.Setter;

    @Getter
    @Setter

public class BillDTORequest {
    private LocalDate date ;
    private Long userId;
    private List <BillDetailDTORequest> details ;
}
