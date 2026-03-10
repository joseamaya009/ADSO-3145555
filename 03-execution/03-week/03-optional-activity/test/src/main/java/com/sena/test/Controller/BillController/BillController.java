package com.sena.test.Controller.BillController;

import com.sena.test.DTO.BillDTO.BillDTORequest;
import com.sena.test.DTO.BillDTO.BillDTOResponse;
import com.sena.test.IService.IBillService.IServiceBill;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/bills")
public class BillController {

    private final IServiceBill service;

    public BillController(IServiceBill service) {
        this.service = service;
    }

    @PostMapping
    public BillDTOResponse create(@RequestBody BillDTORequest dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<BillDTOResponse> findAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public BillDTOResponse findById(@PathVariable Long id) {
        return service.findById(id);
    }
}