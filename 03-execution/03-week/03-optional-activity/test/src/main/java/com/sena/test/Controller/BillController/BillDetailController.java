package com.sena.test.Controller.BillController;

import com.sena.test.DTO.BillDTO.BillDetailDTORequest;
import com.sena.test.DTO.BillDTO.BillDetailDTOResponse;
import com.sena.test.IService.IBillService.IServiceBillDetail;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/bill-details")
public class BillDetailController {

    private final IServiceBillDetail service;

    public BillDetailController(IServiceBillDetail service) {
        this.service = service;
    }

    @PostMapping("/bill/{billId}")
    public BillDetailDTOResponse create(@PathVariable Long billId, @RequestBody BillDetailDTORequest dto) {
        return service.createDetail(billId, dto);
    }

    @GetMapping("/bill/{billId}")
    public List<BillDetailDTOResponse> getDetails(@PathVariable Long billId) {
        return service.getDetailsByBill(billId);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.deleteDetail(id);
    }
}