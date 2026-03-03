package com.sena.test.IService.IBillService;

    import java.util.List;

    import com.sena.test.DTO.BillDTO.BillDTOResponse;
    import com.sena.test.DTO.BillDTO.BillDTORequest;

public interface IServiceBill {
     BillDTOResponse  create (BillDTORequest dto );
 
    List<BillDTOResponse> findAll();
    BillDTOResponse  findById(Long id);
}
