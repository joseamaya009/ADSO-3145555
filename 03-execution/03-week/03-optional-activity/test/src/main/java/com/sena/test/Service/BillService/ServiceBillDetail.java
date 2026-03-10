package com.sena.test.Service.BillService;

import com.sena.test.DTO.BillDTO.*;
import com.sena.test.Entity.Bill.*;
import com.sena.test.Entity.Inventory.Product;
import com.sena.test.IRepository.IBillRepository.*;
import com.sena.test.IRepository.IInventoryRepository.IRepositoryProduct;
import com.sena.test.IService.IBillService.IServiceBillDetail;
import com.sena.test.Utils.BillDetailMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceBillDetail implements IServiceBillDetail {

    private final IRepositoryBill repositoryBill;
    private final IRepositoryBillDetail repositoryDetail;
    private final IRepositoryProduct repositoryProduct;

    public ServiceBillDetail(IRepositoryBill repositoryBill,
                             IRepositoryBillDetail repositoryDetail,
                             IRepositoryProduct repositoryProduct) {

        this.repositoryBill = repositoryBill;
        this.repositoryDetail = repositoryDetail;
        this.repositoryProduct = repositoryProduct;
    }

    @Override
    public BillDetailDTOResponse createDetail(Long billId, BillDetailDTORequest dto) {

        Bill bill = repositoryBill.findById(billId)
                .orElseThrow(() -> new RuntimeException("Factura no encontrada"));

        Product product = repositoryProduct.findById(dto.getProductId())
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        BillDetail detail = BillDetailMapper.toEntity(dto, bill, product);

        detail = repositoryDetail.save(detail);

        double total = repositoryDetail.findByBillId(billId).stream()
                .mapToDouble(d -> d.getPrice() * d.getQuantity())
                .sum();

        bill.setTotal(total);
        repositoryBill.save(bill);

        return BillDetailMapper.toResponseDTO(detail);
    }

    @Override
    public List<BillDetailDTOResponse> getDetailsByBill(Long billId) {
        return repositoryDetail.findByBillId(billId)
                .stream()
                .map(BillDetailMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteDetail(Long id) {
        repositoryDetail.deleteById(id);
    }
}